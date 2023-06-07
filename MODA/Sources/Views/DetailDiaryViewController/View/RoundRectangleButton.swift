//
//  RoundRectangleButton.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class RoundRectangleButton: UIButton {
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    func setSystemImage(imageName: String) {
        let image = UIImage(systemName: imageName)
        self.symbolImageView.image = image
    }
    
    func configureUI() {
        addSubview(symbolImageView)
        
        symbolImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
}
