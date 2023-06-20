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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        self.view.addGestureRecognizer(tapGesture)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: nil)
        self.controller.view.addGestureRecognizer(tapGesture2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        showBottomSheet()
    }
    
    @objc func didTapBackground() {
        self.dismiss(animated: true)
    }
    
    func showBottomSheet() {
        UIView.transition(with: self.view, duration: 0.3) {
            self.view.backgroundColor = .gray.withAlphaComponent(0.3)
        }
    }
}

private extension BottomSheetViewController {
    func configureUI() {
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
