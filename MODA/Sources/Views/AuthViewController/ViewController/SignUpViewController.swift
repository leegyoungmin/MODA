//
//  SignUpViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class SignUpViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor(named: "BackgroundColor")
        label.text = "회원가입"
        return label
    }()
    
    private let idFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "아이디")
        return formView
    }()
    
    private let verifyImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증 메일 보내기", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var emailFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "이메일", additionalView: verifyImageButton)
        return formView
    }()
    
    private let passwordFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "비밀번호")
        return formView
    }()
    
    private let passwordConfirmView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "비밀번호 확인")
        return formView
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setTitle("회원가입하기", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SignUpViewModel(
            useCase: DefaultSignUpUseCase(
                repository: DefaultAuthRepository(
                    service: UserService()
                )
            )
        )
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

private extension SignUpViewController {
    func bindingToViewModel() {
        let input = SignUpViewModel.Input(
            id: idFormView.textField.rx.text.orEmpty.asObservable(),
            email: emailFormView.textField.rx.text.orEmpty.asObservable(),
            password: passwordFormView.textField.rx.text.orEmpty.asObservable(),
            passwordConfirm: passwordConfirmView.textField.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}

private extension SignUpViewController {
    func configureUI() {
        view.backgroundColor = .white
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [
            titleLabel,
            idFormView,
            emailFormView,
            passwordFormView,
            passwordConfirmView,
            signUpButton
        ].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.top.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-44)
        }
        
        idFormView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        emailFormView.snp.makeConstraints {
            $0.leading.equalTo(idFormView.snp.leading)
            $0.top.equalTo(idFormView.snp.bottom).offset(16)
            $0.trailing.equalTo(idFormView.snp.trailing)
        }
        
        passwordFormView.snp.makeConstraints {
            $0.leading.equalTo(emailFormView.snp.leading)
            $0.top.equalTo(emailFormView.snp.bottom).offset(16)
            $0.trailing.equalTo(emailFormView.snp.trailing)
        }
        
        passwordConfirmView.snp.makeConstraints {
            $0.leading.equalTo(passwordFormView.snp.leading)
            $0.top.equalTo(passwordFormView.snp.bottom).offset(16)
            $0.trailing.equalTo(passwordFormView.snp.trailing)
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.equalTo(passwordConfirmView.snp.leading)
            $0.bottom.equalToSuperview().offset(-32)
            $0.trailing.equalTo(passwordConfirmView.snp.trailing)
        }
    }
}
