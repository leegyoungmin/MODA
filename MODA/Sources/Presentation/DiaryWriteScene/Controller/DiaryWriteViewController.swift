//
//  DiaryWriteViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DiaryWriteViewController: UIViewController {
    private let dismissButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIConstants.Images.xmarkIcon)
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    
    private let scrollViewContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let conditionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "diary_condition_title"~
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "diary_memory_title"~
        return label
    }()
    
    private let goodConditionButton = ConditionButton(symbol: Diary.Condition.good)
    private let normalConditionButton = ConditionButton(symbol: Diary.Condition.normal)
    private let badConditionButton = ConditionButton(symbol: Diary.Condition.bad)
    
    private let conditionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.backgroundColor = UIConstants.Colors.secondaryColor?.cgColor
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.layer.cornerRadius = 14
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let saveButton: DisableButton = {
        let button = DisableButton()
        button.setTitle("save"~, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.selectedColor = UIConstants.Colors.accentColor
        button.disabledColor = UIColor.secondarySystemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        return view
    }()
    
    private var selectedCondition = PublishSubject<Int>()
    private let viewModel: DiaryWriteViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryWriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DiaryWriteViewModel(
            diaryWriteUseCase: DefaultDiaryWriteUseCase(
                diaryRepository: DefaultDiaryRepository(
                    diaryService: DiaryService()
                )
            )
        )
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        [goodConditionButton, normalConditionButton, badConditionButton].forEach {
            $0.delegate = self
        }
        
        bindings()
    }
}

// MARK: - Binding Methods
extension DiaryWriteViewController {
    func bindings() {
        bindingInput()
        
        let conditionSelected = Observable.of(
            goodConditionButton.rx.tap.map { Diary.Condition.good.rawValue },
            normalConditionButton.rx.tap.map { Diary.Condition.normal.rawValue },
            badConditionButton.rx.tap.map { Diary.Condition.bad.rawValue }
        ).merge()
        
        let input = DiaryWriteViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            selectedCondition: conditionSelected.asObservable(),
            descriptionInput: contentTextView.rx.text.orEmpty.asObservable(),
            saveButtonTap: saveButton.rx.tap.asObservable(),
            cancelButtonTap: dismissButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        bindingOutput(output)
    }
    
    func bindingInput() {
        
        Observable.of(
            Notification.keyboardWillShow(),
            Notification.keyboardWillHide()
        )
        .merge()
        .observe(on: MainScheduler.instance)
        .subscribe { [weak self] height in
            guard let self = self else { return }
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            scrollView.contentInset = contentInset
        }
        .disposed(by: disposeBag)
    }
    
    func bindingOutput(_ output: DiaryWriteViewModel.Output) {
        
        output.description
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        output.selectedCondition
            .observe(on: MainScheduler.instance)
            .compactMap { Diary.Condition(rawValue: $0) }
            .subscribe(onNext: { condition in
                switch condition {
                case .good:
                    self.goodConditionButton.selectItem()
                case .normal:
                    self.normalConditionButton.selectItem()
                case .bad:
                    self.badConditionButton.selectItem()
                }
            })
            .disposed(by: disposeBag)
        
        output.disableConfirmButton
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismissView.asObservable()
            .observe(on: MainScheduler.instance)
            .filter { $0 }
            .subscribe { [weak self] isDismiss in
                guard let self = self else { return }
                self.dismiss(animated: isDismiss)
            }
            .disposed(by: disposeBag)
        
        output.saveState
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .success:
                    self.loadingView.stopAnimating()
                case .loading:
                    self.loadingView.startAnimating()
                case .failure:
                    self.presentErrorAlert()
                default:
                    self.loadingView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension DiaryWriteViewController {
    func presentErrorAlert() {
        let controller = UIAlertController(
            title: "unknown_error_title"~,
            message: "unknown_error_message"~,
            preferredStyle: .alert
        )
        controller.addAction(UIAlertAction(title: "confirm"~, style: .default, handler: { _ in
            self.loadingView.stopAnimating()
        }))
        self.present(controller, animated: true)
    }
}

// MARK: Condition Button Delegate Method
extension DiaryWriteViewController: ConditionButtonDelegate {
    func conditionButton(
        _ button: ConditionButton,
        didTapButton condition: Diary.Condition
    ) {
        let stackSubviews = conditionStackView.arrangedSubviews
        guard let conditionButtons = stackSubviews as? [ConditionButton] else { return }
        
        conditionButtons.forEach { button in
            UIView.animate(withDuration: 0.4) {
                if button.isSelected == true && button.condition != condition {
                    button.isSelected = false
                }
            }
        }
    }
}

// MARK: - UI 구성 관련 메서드
private extension DiaryWriteViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [scrollView, saveButton].forEach(view.addSubview)
        
        scrollView.addSubview(scrollViewContentView)
        
        [badConditionButton, normalConditionButton, goodConditionButton]
            .forEach(conditionStackView.addArrangedSubview)
        [conditionTitleLabel, contentTitleLabel, contentTextView, conditionStackView, loadingView]
            .forEach(scrollViewContentView.addSubview)
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.title = Date().toString("yyyy. MM. dd")
    }
    
    func makeConstraints() {
        saveButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-28)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        
        scrollViewContentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        conditionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(scrollViewContentView.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        conditionStackView.snp.makeConstraints {
            $0.top.equalTo(conditionTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(conditionStackView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(scrollViewContentView.snp.bottom).offset(-20)
            $0.height.greaterThanOrEqualTo(view.snp.height).multipliedBy(0.5)
        }
        
        loadingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
