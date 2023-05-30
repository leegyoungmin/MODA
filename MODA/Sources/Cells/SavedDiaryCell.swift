//
//  SavedDiaryCell.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SavedDiaryCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "BackgroundColor")
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(named: "BackgroundColor")?.cgColor
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        return label
    }()
    
    func setUpData(to diary: Diary) {
        self.dateLabel.text = diary.meta.day
        self.conditionLabel.text = diary.condition.description
        self.contentLabel.text = diary.content
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        )
    }
}

private extension SavedDiaryCell {
    func configureUI() {
        contentView.backgroundColor = UIColor(named: "SecondaryColor")
        contentView.layer.cornerRadius = 12
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [dateLabel, conditionLabel, dividerView, contentLabel].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.height.lessThanOrEqualTo(50)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(dateLabel.snp.height)
        }
        
        dividerView.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.trailing.equalTo(conditionLabel.snp.trailing)
            $0.height.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(12)
            $0.leading.equalTo(dateLabel.snp.leading)
            $0.trailing.equalTo(conditionLabel.snp.trailing)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}
