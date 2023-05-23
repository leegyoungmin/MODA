//
//  ConditionButton.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ConditionButton: UIButton {
    private var symbol: String = ""
    
    init(symbol: String) {
        self.symbol = symbol
        super.init(frame: .zero)
        
        self.titleLabel?.font = .systemFont(ofSize: 48)
        self.setTitle(symbol, for: .normal)
        self.layer.backgroundColor = UIColor(named: "SecondaryColor")?.cgColor
        self.layer.cornerRadius = 12
        self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
