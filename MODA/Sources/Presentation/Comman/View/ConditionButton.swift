//
//  ConditionButton.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

protocol ConditionButtonDelegate: AnyObject {
    func conditionButton(_ button: ConditionButton, didTapButton condition: Diary.Condition)
}

final class ConditionButton: UIButton {
    private(set) var condition: Diary.Condition
    
    weak var delegate: ConditionButtonDelegate?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.layer.backgroundColor = UIConstants.Colors.accentColor?.cgColor
            } else {
                self.layer.backgroundColor = UIConstants.Colors.secondaryColor?.cgColor
            }
        }
    }
    
    
    init(symbol: Diary.Condition) {
        self.condition = symbol
        
        super.init(frame: .zero)
        
        self.titleLabel?.font = .systemFont(ofSize: 48)
        self.setTitle(symbol.description, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.backgroundColor = UIConstants.Colors.secondaryColor?.cgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    required init?(coder: NSCoder) {
        self.condition = .good
        super.init(coder: coder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        selectItem()
    }
    
    func selectItem() {
        self.isSelected = true
        delegate?.conditionButton(self, didTapButton: condition)
    }
}
