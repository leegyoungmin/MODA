//
//  RoundRectangleButton.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class RoundRectangleButton: UIButton {
    override var isEnabled: Bool {
        willSet {
            if newValue == false {
                imageView?.tintColor = .darkGray
            } else {
                imageView?.tintColor = nil
            }
        }
    }
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
