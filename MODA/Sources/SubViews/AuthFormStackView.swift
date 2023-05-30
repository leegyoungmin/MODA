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
        label.textColor = UIColor(named: "BackgroundColor")
        return label
    }()
    
    private let textField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = UIColor(named: "SecondaryColor")
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private var additionalView: UIView?
    
    init(title: String, additionalView: UIView? = nil) {
        self.additionalView = additionalView
        super.init(frame: .zero)
        
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
        var childViews = [titleLabel, textField]
        
        if let additionalView = additionalView {
            childViews.append(additionalView)
        }
        
        childViews.forEach(addArrangedSubview)
    }
}
