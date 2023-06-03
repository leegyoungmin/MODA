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
        label.text = "오늘은 컨디션이 어떤가요?"
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "오늘을 기억할 수 있는 말을 적어보세요."
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
        textView.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        textView.font = .systemFont(ofSize: 20)
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.layer.cornerRadius = 14
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let saveButton: DisableButton = {
        let button = DisableButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.selectedColor = UIColor(named: "AccentColor")
        button.disabledColor = UIColor.secondarySystemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedCondition = PublishSubject<Int>()
    private let viewModel: DiaryWriteViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: DiaryWriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = DiaryWriteViewModel()
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

extension DiaryWriteViewController {
    func bindings() {
        keyboardHeight()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] height in
                guard let self = self else { return }
                
                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                scrollView.contentInset = contentInset
            }
            .disposed(by: disposeBag)
        
        let input = DiaryWriteViewModel.Input(
            selectedCondition: selectedCondition.asObservable(),
            descriptionInput: contentTextView.rx.text.orEmpty.asObservable(),
            saveButtonTap: saveButton.rx.tap.asObservable(),
            cancelButtonTap: navigationItem.leftBarButtonItem?.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.disableConfirmButton
            .debug()
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.dismissView.asObservable()
            .filter { $0 }
            .subscribe { [weak self] isDismiss in
                guard let self = self else { return }
                self.dismiss(animated: isDismiss)
            }
            .disposed(by: disposeBag)
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
        
        self.selectedCondition.onNext(condition.rawValue)
        
        conditionButtons.forEach { button in
            UIView.animate(withDuration: 0.4) {
                if button.isSelected == true && button.condition != condition {
                    button.isSelected = false
                }
            }
        }
    }
}

private extension DiaryWriteViewController {
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillShowNotification)
                    .map {
                        ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                    },
                
                NotificationCenter.default.rx
                    .notification(UIResponder.keyboardWillHideNotification)
                    .map { _ in 0 }
            ])
            .merge()
    }
}

private extension DiaryWriteViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        scrollView.addSubview(scrollViewContentView)
        
        [badConditionButton, normalConditionButton, goodConditionButton]
            .forEach(conditionStackView.addArrangedSubview)
        [conditionTitleLabel, contentTitleLabel, contentTextView, conditionStackView]
            .forEach(scrollViewContentView.addSubview)
    }
    
    func configureNavigationBar() {
        let dismissAction = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        let dismissButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark.circle.fill"),
            primaryAction: dismissAction
        )
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.title = Date().toString("yy년 MM월 dd일")
    }
    
    func makeConstraints() {
        saveButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
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
    }
}
