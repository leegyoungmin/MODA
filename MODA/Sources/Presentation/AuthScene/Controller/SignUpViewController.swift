//
//  SignUpViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

final class SignUpViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIConstants.Colors.backgroundColor
        label.text = "sign_up"~
        return label
    }()
    
    private let idFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "auth_id"~)
        return formView
    }()
    
    private let verifyImageButton: DisableButton = {
        let button = DisableButton()
        button.setTitle("send_email"~, for: .normal)
        button.disabledColor = UIColor.secondarySystemBackground
        button.selectedColor = UIConstants.Colors.accentColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private lazy var emailFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "email"~, additionalView: verifyImageButton)
        return formView
    }()
    
    private let passwordFormView: AuthFormStackView = {
        let formView = AuthFormStackView(
            title: "auth_password"~,
            warning: "password_length_warning"~
        )
        formView.textField.isSecureTextEntry = true
        return formView
    }()
    
    private let passwordConfirmView: AuthFormStackView = {
        let formView = AuthFormStackView(
            title: "password_confirm"~,
            warning: "password_warning"~
        )
        formView.warningLabel.isHidden = false
        formView.textField.isSecureTextEntry = true
        return formView
    }()
    
    private let signUpButton: DisableButton = {
        let button = DisableButton()
        button.disabledColor = UIColor.secondarySystemBackground
        button.selectedColor = UIConstants.Colors.accentColor
        button.setTitle("sign_up"~, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    private let viewModel: SignUpViewModel
    private var disposeBag = DisposeBag()
    
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
        bindingToViewModel()
    }
}

private extension SignUpViewController {
    func bindingToViewModel() {
        let input = SignUpViewModel.Input(
            id: idFormView.textField.rx.text.orEmpty.asObservable(),
            email: emailFormView.textField.rx.text.orEmpty.asObservable(),
            password: passwordFormView.textField.rx.text.orEmpty.asObservable(),
            passwordConfirm: passwordConfirmView.textField.rx.text.orEmpty.asObservable(),
            didTapSignUpButton: signUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        bindingFromViewModel(output)
    }
    
    func bindingFromViewModel(_ output: SignUpViewModel.Output) {
        output.emailValid
            .bind(to: verifyImageButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.passwordLength
            .bind(to: passwordFormView.warningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordValid
            .bind(to: passwordConfirmView.warningLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.signUpValid
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.signUpUser
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                
                if user.sessionToken.isEmpty == true {
                    presentErrorAlert()
                } else {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension SignUpViewController {
    func presentErrorAlert() {
        let alert = UIAlertController(
            title: "user_already_title"~,
            message: "user_already_message"~,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "confirm"~, style: .default))
        self.present(alert, animated: true)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.trailing.equalTo(titleLabel.snp.trailing)
        }
        
        emailFormView.snp.makeConstraints {
            $0.leading.equalTo(idFormView.snp.leading)
            $0.top.equalTo(idFormView.snp.bottom).offset(12)
            $0.trailing.equalTo(idFormView.snp.trailing)
        }
        
        passwordFormView.snp.makeConstraints {
            $0.leading.equalTo(emailFormView.snp.leading)
            $0.top.equalTo(emailFormView.snp.bottom).offset(12)
            $0.trailing.equalTo(emailFormView.snp.trailing)
        }
        
        passwordConfirmView.snp.makeConstraints {
            $0.leading.equalTo(passwordFormView.snp.leading)
            $0.top.equalTo(passwordFormView.snp.bottom).offset(12)
            $0.trailing.equalTo(passwordFormView.snp.trailing)
        }
        
        signUpButton.snp.makeConstraints {
            $0.leading.equalTo(passwordConfirmView.snp.leading)
            $0.bottom.equalToSuperview().offset(-32)
            $0.trailing.equalTo(passwordConfirmView.snp.trailing)
        }
    }
}
