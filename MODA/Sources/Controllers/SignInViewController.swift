//
//  SignInViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    private let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "BackgroundColor")
        label.text = "아이디"
        return label
    }()
    
    private let idTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = UIColor(named: "SecondaryColor")
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: "BackgroundColor")
        label.text = "비밀번호"
        return label
    }()
    
    private let passWordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = UIColor(named: "SecondaryColor")
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let idStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.distribution = .fill
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        return contentStackView
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 8
        button.setTitle("로그인하기", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 계정이 없으신가요?"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입하러 가기", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindings()
    }
}

private extension SignInViewController {
    func bindings() {
        signInButton.rx.tap
            .bind { _ in
                print("Tapped Sign In Button")
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind { _ in
                print("Tapped Present SignUp Button")
            }
            .disposed(by: disposeBag)
    }
}

private extension SignInViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [idLabel, idTextField].forEach(idStackView.addArrangedSubview)
        [passwordLabel, passWordTextField].forEach(passwordStackView.addArrangedSubview)
        [signUpLabel, signUpButton].forEach(signUpStackView.addArrangedSubview)
        
        [idStackView, passwordStackView, signInButton, signUpStackView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        
        idStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.trailing.equalToSuperview().offset(-44)
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        passwordStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.trailing.equalToSuperview().offset(-44)
            $0.top.equalTo(idStackView.snp.bottom).offset(8)
        }
        
        signInButton.snp.makeConstraints {
            $0.leading.equalTo(passwordStackView.snp.leading)
            $0.trailing.equalTo(passwordStackView.snp.trailing)
            $0.top.equalTo(passwordStackView.snp.bottom).offset(28)
        }
        
        signUpStackView.snp.makeConstraints {
            $0.centerX.equalTo(signInButton)
            $0.top.equalTo(signInButton.snp.bottom).offset(24)
        }
    }
}

class PaddingTextField: UITextField {
    var textPadding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
