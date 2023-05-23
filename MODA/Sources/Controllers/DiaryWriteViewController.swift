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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "오늘은 컨디션이 어떤가요?"
        return label
    }()
    
    private let contentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘을 기억할 수 있는 말을 적어보세요."
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        textView.layer.cornerRadius = 12
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureUI()
    }
}

private extension DiaryWriteViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [conditionTitleLabel, contentTitleLabel, contentTextView]
            .forEach(view.addSubview)
    }
    
    func makeConstraints() {
        conditionTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(conditionTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
    }
}
