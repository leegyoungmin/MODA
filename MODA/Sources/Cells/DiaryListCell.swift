//
//  DiaryListCell.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class DiaryListCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = UIColor(named: "AccentColor")
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 48)
        label.textAlignment = .center
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 10
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = UIColor(named: "SecondaryColor")
        
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
    
    func setUpDatas(to diary: Diary) {
        createdDateLabel.text = diary.meta.day
        conditionLabel.text = diary.condition.description
        contentLabel.text = diary.content
    }
}

private extension DiaryListCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [createdDateLabel, conditionLabel, dividerView, contentLabel]
            .forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        createdDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.height.equalTo(50).priority(.high)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(createdDateLabel.snp.trailing)
            $0.bottom.equalTo(contentView.snp.centerY)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.top)
            $0.leading.equalTo(createdDateLabel.snp.trailing).offset(12)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.top)
            $0.bottom.equalTo(dividerView.snp.bottom)
            $0.leading.equalTo(dividerView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
        }
    }
}
