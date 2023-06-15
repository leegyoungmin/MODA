//
//  UIPaddingTextField.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class UIPaddingTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
