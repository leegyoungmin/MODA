//
//  DiaryListCell.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class DiaryListCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .natural
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
        label.numberOfLines = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor(named: "AccentColor")
        contentView.layer.cornerRadius = 12
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    func setUpDatas(to diary: Diary) {
        createdDateLabel.text = diary.meta.createdDate.description
        conditionLabel.text = diary.condition.rawValue.description
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
            $0.top.leading.equalToSuperview()
            $0.height.lessThanOrEqualTo(50)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.top).offset(12)
            $0.leading.equalTo(createdDateLabel.snp.trailing).offset(12)
            $0.bottom.equalTo(conditionLabel.snp.bottom)
            $0.width.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.top)
            $0.bottom.equalTo(dividerView.snp.bottom)
            $0.leading.equalTo(dividerView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
    }
}
