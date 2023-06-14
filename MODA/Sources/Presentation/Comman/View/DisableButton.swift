//
//  DisableButton.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class DisableButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.layer.backgroundColor = selectedColor?.cgColor
            } else {
                self.layer.backgroundColor = disabledColor?.cgColor
            }
        }
    }
    
    var selectedColor: UIColor?
    var disabledColor: UIColor?
}
