//
//  AlertController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class AlertController: UIViewController {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "BackgroundColor")
        label.textAlignment = .center
        label.text = "보고 싶은 달을 선택해주세요."
        return label
    }()

    private let confirmButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.layer.cornerRadius = 12
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private var titleDescription: String?
    private var isTapDismiss: Bool = true
    private var hasCancelButton: Bool = false
    private var contentView: UIView?
    private var buttonHandler: () -> Void = { }
    
    convenience init(
        title: String,
        isTapDismiss: Bool = true,
        hasCancelButton: Bool = false,
        contentView: UIView? = nil,
        buttonHandler: @escaping () -> Void
    ) {
        self.init(nibName: nil, bundle: nil)
        self.titleDescription = title
        self.isTapDismiss = isTapDismiss
        self.hasCancelButton = hasCancelButton
        self.contentView = contentView
        self.buttonHandler = buttonHandler
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        confirmButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                if self.isTapDismiss {
                    self.dismiss(animated: true) {
                        self.buttonHandler()
                    }
                } else {
                    self.buttonHandler()
                    self.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension AlertController {
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        view.addSubview(containerView)
        
        [titleLabel, confirmButton].forEach(containerView.addSubview)
        
        if let contentView = contentView {
            containerView.addSubview(contentView)
        }
    }
    
    func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()

            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        if let contentView = contentView {
            contentView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            }
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-12)
            $0.trailing.equalToSuperview().offset(-16)
            
            if let contentView = contentView {
                $0.top.equalTo(contentView.snp.bottom).offset(12)
            } else {
                $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            }
        }
    }
}
