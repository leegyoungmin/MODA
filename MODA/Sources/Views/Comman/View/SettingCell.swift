//
//  SettingCell.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SettingCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "BackgroundColor")
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentActionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(named: "BackgroundColor"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpData(to setting: SettingOption) {
        self.titleLabel.text = setting.title
        
        if setting.content.isEmpty == false {
            self.contentActionButton.setTitle(setting.content, for: .normal)
            self.contentActionButton.backgroundColor = UIColor.white
        }
    }
    
    func updateContent(_ value: String) {
        contentActionButton.setTitle(value, for: .normal)
    }
}

private extension SettingCell {
    func configureUI() {
        backgroundColor = UIColor(named: "SecondaryColor")
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, contentActionButton].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.layoutMargins).offset(16)
            $0.top.equalTo(contentView.layoutMargins)
            $0.bottom.equalTo(contentView.layoutMargins)
        }
        
        contentActionButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.bottom.equalTo(titleLabel.snp.bottom)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.3)
        }
    }
}
