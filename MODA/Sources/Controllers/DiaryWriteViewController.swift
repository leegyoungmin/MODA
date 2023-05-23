//
//  DiaryWriteViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import SnapKit

final class DiaryWriteViewController: UIViewController {
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
        label.text = "오늘을 기억할 수 있는 말을 적어보세요."
        return label
    }()
    
    private let goodConditionButton = ConditionButton(symbol: Diary.Condition.good.description)
    private let normalConditionButton = ConditionButton(symbol: Diary.Condition.normal.description)
    private let badConditionButton = ConditionButton(symbol: Diary.Condition.bad.description)
    
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
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.backgroundColor = UIColor(named: "AccentColor")?.cgColor
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
    }
}

private extension DiaryWriteViewController {
    func configureUI() {
        configureNavigationBar()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [badConditionButton, normalConditionButton, goodConditionButton]
            .forEach(conditionStackView.addArrangedSubview)
        [conditionTitleLabel, contentTitleLabel, contentTextView, conditionStackView, saveButton]
            .forEach(view.addSubview)
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
    }
    
    func makeConstraints() {
        conditionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        conditionStackView.snp.makeConstraints {
            $0.top.equalTo(conditionTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(conditionStackView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(28)
            $0.leading.equalTo(view.snp.leading).offset(22)
            $0.trailing.equalTo(view.snp.trailing).offset(-22)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
}
