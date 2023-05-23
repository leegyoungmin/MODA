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
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .natural
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    func setUpDatas(to diary: Diary) {
        createdDateLabel.text = diary.meta.createdDate.description
        conditionLabel.text = diary.condition.rawValue.description
    }
}

private extension DiaryListCell {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [createdDateLabel, conditionLabel].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        createdDateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(12)
        }
        
        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(createdDateLabel.snp.bottom)
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
}
