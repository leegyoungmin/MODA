//
//  DetailDiaryViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class DetailDiaryViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIConstants.Colors.secondaryColor
        textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.font = .systemFont(ofSize: 18)
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private let likeButton: RoundRectangleButton = {
        let button = RoundRectangleButton()
        button.setImage(UIConstants.Images.star, for: .normal)
        button.setImage(UIConstants.Images.starFill, for: .selected)
        return button
    }()
    
    private let editButton: RoundRectangleButton = {
        let button = RoundRectangleButton()
        button.setImage(UIConstants.Images.pencil, for: .normal)
        button.setImage(UIConstants.Images.arrowUp, for: .selected)
        return button
    }()
    
    private let removeButton: RoundRectangleButton = {
        let button = RoundRectangleButton()
        button.setImage(UIConstants.Images.trash, for: .normal)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    private let viewModel: DetailDiaryViewModel?
    private let editMode = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: DetailDiaryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        bindingFromViewModel()
        bindingUI()
    }
    
    func bindingFromViewModel() {
        let input = DetailDiaryViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            didTapSaveButton: editButton.rx.tap.asObservable(),
            isEditMode: editMode.asObservable(),
            editedContent: contentTextView.rx.text.changed.asObservable(),
            didTapLikeButton: likeButton.rx.tap.asObservable(),
            didTapDeleteButton: removeButton.rx.tap.asObservable(),
            viewWillDisappear: rx.methodInvoked(#selector(viewWillDisappear)).map { _ in }.asObservable()
        )
        
        let output = viewModel?.transform(input: input)
        
        output?.createdDate
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.condition
            .compactMap { $0?.description }
            .bind(to: conditionLabel.rx.text)
            .disposed(by: disposeBag)
        
        output?.content
            .bind(to: contentTextView.rx.text)
            .disposed(by: disposeBag)
        
        output?.isLike
            .bind(to: likeButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        output?.isEditable
            .bind(to: editButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output?.didSuccessRemove
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
            
    }
    
    func bindingUI() {
        editButton.rx.tap
            .map { self.editButton.isSelected }
            .bind(to: editMode)
            .disposed(by: disposeBag)
        
        editMode.subscribe { [weak self] in
            guard let self = self else { return }
            
            self.contentTextView.isEditable = !$0
            self.editButton.isSelected = !$0
        }
        .disposed(by: disposeBag)
    }
}

private extension DetailDiaryViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureHierarchy() {
        [likeButton, editButton, removeButton].forEach(buttonStackView.addArrangedSubview)
        [titleLabel, conditionLabel, contentTextView, buttonStackView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(titleLabel.snp.bottom)
        }
        
        contentTextView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(conditionLabel.snp.trailing)
            $0.top.equalTo(conditionLabel.snp.bottom).offset(16)
            $0.height.lessThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.top.equalTo(contentTextView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
