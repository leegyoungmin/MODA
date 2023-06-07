//
//  DetailDiaryViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class RoundRectangleButton: UIButton {
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    func setSystemImage(imageName: String) {
        let image = UIImage(systemName: imageName)
        self.symbolImageView.image = image
    }
    
    func configureUI() {
        addSubview(symbolImageView)
        
        symbolImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}

final class DetailDiaryViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = Date().toString("yyyy년 MM월 dd일")
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .semibold)
        label.text = Diary.Condition.good.description
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.backgroundColor = UIColor(named: "SecondaryColor")
        return textView
    }()
    
    private let likeButton: RoundRectangleButton = {
        let button = RoundRectangleButton()
        button.setSystemImage(imageName: "heart")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        configureUI()
    }
}

private extension DetailDiaryViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, conditionLabel, contentTextView, likeButton].forEach(view.addSubview)
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
            $0.top.equalTo(conditionLabel.snp.bottom).offset(32)
            $0.height.lessThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        likeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.top.equalTo(contentTextView.snp.bottom).offset(16)
            $0.width.equalTo(likeButton.snp.height).multipliedBy(1)
        }
    }
}
