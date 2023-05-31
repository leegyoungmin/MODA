//
//  MonthStackView.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class MonthStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 16
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        self.layer.cornerRadius = 12
        
        configureHierarchy()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.distribution = .fillEqually
        
        configureHierarchy()
    }
    
    private func configureButtons() -> [[UIButton]] {
        var buttons = Array(repeating: [UIButton](), count: 3)
        
        for month in 0..<12 {
            let button = UIButton()
            button.setTitle("\(month + 1)월", for: .normal)
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.layer.cornerRadius = 12
            
            buttons[month / 4].append(button)
        }
        
        return buttons
    }
    
    private func configureStackView() -> [UIStackView] {
        var stackViews = [UIStackView]()
        
        for _ in 0..<3 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 8
            stackView.isLayoutMarginsRelativeArrangement = false
            
            stackViews.append(stackView)
        }
        
        return stackViews
    }
}

private extension MonthStackView {
    func configureHierarchy() {
        let stackViews = configureStackView()
        
        configureButtons().enumerated().forEach { buttonInfo in
            buttonInfo.element.forEach { button in
                stackViews[buttonInfo.offset].addArrangedSubview(button)
            }
        }
        
        stackViews.forEach(self.addArrangedSubview)
    }
}
