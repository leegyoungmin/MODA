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
        configureUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureButtons() -> [[UIButton]] {
        var buttons = Array(repeating: [UIButton](), count: 3)
        
        for month in 0..<12 {
            let button = UIButton()
            button.setTitle("\(month + 1)월", for: .normal)
            button.setTitleColor(.red, for: .normal)
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
            
            stackViews.append(stackView)
        }
        
        return stackViews
    }
}

private extension MonthStackView {
    func configureUI() {
        configureHierarchy()
    }
    
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
