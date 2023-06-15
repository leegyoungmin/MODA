//
//  BottomSheetViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class BottomSheetViewController: UIViewController {
    private let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.controller = UIViewController()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        self.view.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: nil)
        self.controller.view.addGestureRecognizer(tapGesture2)
    }
    
    @objc func didTapBackground() {
        self.dismiss(animated: true)
    }
}

private extension BottomSheetViewController {
    func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.layer.cornerRadius = 12
    }
    
    func makeConstraints() {
        controller.view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-32)
            $0.height.equalToSuperview().multipliedBy(0.45)
        }
    }
}
