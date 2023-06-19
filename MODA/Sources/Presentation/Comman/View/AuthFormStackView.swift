//
//  AuthFormStackView.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class AuthFormStackView: UIStackView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIConstants.Colors.backgroundColor
        return label
    }()
    
    let textField: UIPaddingTextField = {
        let textField = UIPaddingTextField()
        textField.backgroundColor = UIConstants.Colors.secondaryColor
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let warningLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        label.textColor = .red.withAlphaComponent(0.5)
        return label
    }()
    
    private var additionalView: UIView?
    
    init(title: String, warning: String? = nil, additionalView: UIView? = nil) {
        self.additionalView = additionalView
        super.init(frame: .zero)
        
        warningLabel.text = warning
        titleLabel.text = title
        self.spacing = 8
        self.axis = .vertical
        self.distribution = .fillEqually
        
        attachSubViews()
    }
    
    required init(coder: NSCoder) {
        self.additionalView = nil
        
        super.init(coder: coder)
        
        attachSubViews()
    }
    func attachSubViews() {
        var childViews = [titleLabel, textField, warningLabel]
        
        if let additionalView = additionalView {
            childViews.append(additionalView)
        }
        
        childViews.forEach(addArrangedSubview)
    }
}
