//
//  AlertController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class AlertController: UIViewController {
    
    enum AlertType {
        case onlyConfirm(confirmMessage: String)
        case canCancel(confirmMessage: String, cancelMessage: String)
        
        var tag: Int {
            switch self {
            case .onlyConfirm:      return 0
            case .canCancel:        return 1
            }
        }
    }
    
    enum TitleType {
        case text(title: String)
        case custom
        
        var tag: Int {
            switch self {
            case .text:      return 0
            case .custom:        return 1
            }
        }
    }
    
    enum ContentType {
        case text(message: String)
        case custom
        
        var tag: Int {
            switch self {
            case .text:      return 0
            case .custom:        return 1
            }
        }
    }
    
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
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor(named: "AccentColor")
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
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "SecondaryColor")
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        button.layer.cornerRadius = 12
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var alertType: AlertType = .onlyConfirm(confirmMessage: "확인")
    private var titleType: TitleType = .text(title: "")
    private var contentType: ContentType = .text(message: "")
    
    private var titleValue: String?
    private var contentValue: String?
    private var confirmMessage: String?
    private var cancelMessage: String?
    
    private var titleView: UIView?
    private var contentView: UIView?
    
    init(
        alertType: AlertType = .onlyConfirm(confirmMessage: "확인"),
        titleType: TitleType = .text(title: ""),
        contentType: ContentType = .text(message: ""),
        titleView: UIView? = nil,
        contentView: UIView? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        
        self.alertType = alertType
        self.titleType = titleType
        self.contentType = contentType
        
        self.titleView = titleView
        self.contentView = contentView
        
        setTitleValue(titleType: titleType)
        setContentValues(contentType: contentType)
        setButtonsValues(alertType: alertType)
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
    }
}

private extension AlertController {
    func setTitleValue(titleType: TitleType) {
        if case let .text(title) = titleType {
            self.titleValue = title
        }
    }
    
    func setContentValues(contentType: ContentType) {
        if case let .text(message) = contentType {
            self.contentValue = message
        }
    }
    
    func setButtonsValues(alertType: AlertType) {
        
        switch alertType {
        case .onlyConfirm(let confirmMessage):
            self.confirmMessage = confirmMessage

        case .canCancel(let confirmMessage, let cancelMessage):
            self.confirmMessage = confirmMessage
            self.cancelMessage = cancelMessage
        }
    }
}

// MARK: View 제약 관련 메서드
private extension AlertController {
    func configureUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configureHierarchy()
        makeConstraints()
    }
    
    func makeTitleConstraints() {
        let titleView = (titleType.tag == 0) ? titleLabel : titleView
        
        if let titleView = titleView {
            titleView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.top.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
            }
        }
    }
    
    func makeContentConstraints() {
        let contentView = (contentType.tag == 0) ? messageLabel : contentView
        
        if let contentView = contentView {
            contentView.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().offset(-16)
                
                if let titleView = titleView {
                    $0.top.equalTo(titleView.snp.bottom).offset(16)
                } else {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(16)
                }
            }
        }
    }
    
    func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            
            $0.width.equalTo(view.snp.width).multipliedBy(0.9)
        }
        
        makeTitleConstraints()
        makeContentConstraints()
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
            
            if let contentView = contentView {
                $0.top.equalTo(contentView.snp.bottom).offset(12)
            } else {
                $0.top.equalTo(messageLabel.snp.bottom).offset(12)
            }
        }
    }
}

// MARK: Hierarchy 설정 관련 메서드
private extension AlertController {
    func configureHierarchy() {
        view.addSubview(containerView)
        
        configureTitleHierarchy()
        configureContentHierarchy()
        configureButtonsHierarchy()
    }
    
    func configureTitleHierarchy() {
        let titleView = (titleType.tag == 0) ? titleLabel : titleView

        if let titleView = titleView {
            containerView.addSubview(titleView)
        }
    }
    
    func configureContentHierarchy() {
        let contentView = (contentType.tag == 0) ? messageLabel : contentView
        
        if let contentView = contentView {
            containerView.addSubview(contentView)
        }
    }
    
    func configureButtonsHierarchy() {
        switch alertType {
        case .onlyConfirm:
            [confirmButton].forEach(buttonStackView.addArrangedSubview)
            
        case .canCancel:
            [cancelButton, confirmButton].forEach(buttonStackView.addArrangedSubview)
        }
        
        containerView.addSubview(buttonStackView)
    }
}
