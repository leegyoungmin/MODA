//
//  SignInViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIConstants.Images.appIcon
        return imageView
    }()
    
    private let idFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "auth_id"~)
        return formView
    }()
    
    private let passwordFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "auth_password"~)
        return formView
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
        button.backgroundColor = UIConstants.Colors.accentColor
        button.layer.cornerRadius = 8
        button.setTitle("sign_in"~, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "no_account"~
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("go_sign_up"~, for: .normal)
        button.setTitleColor(UIConstants.Colors.accentColor, for: .normal)
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
    
    private let viewModel: SignInViewModel
    private let currentUser = BehaviorSubject<User?>(value: nil)
    private let disposeBag = DisposeBag()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SignInViewModel(
            useCase: DefaultSignInUseCase(
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
        bindingView()
        bindingToViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

private extension SignInViewController {
    func presentMainViewController() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            
            if let delegate = scenes.first?.delegate as? SceneDelegate,
               let window = delegate.window {
                
                window.rootViewController = TabViewController()
            }
        }
    }
}

private extension SignInViewController {
    func bindingToViewModel() {
        let input = SignInViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewDidAppear)).map { _ in }.asObservable(),
            id: idFormView.textField.rx.text.orEmpty.asObservable(),
            password: passwordFormView.textField.rx.text.orEmpty.asObservable(),
            didTapLoginButton: signInButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.isSaved
            .observe(on: MainScheduler.instance)
            .bind(onNext: handleLoginResult)
            .disposed(by: disposeBag)
    }
    
    func bindingView() {
        signUpButton.rx.tap
            .bind(onNext: presentSignUpView)
            .disposed(by: disposeBag)
        
        Notification.keyboardWillShow()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] height in
                guard let self = self else { return }
                
                if view.frame.origin.y == .zero {
                    view.frame.origin.y -= (height / 2)
                }
            }
            .disposed(by: disposeBag)
        
        Notification.keyboardWillHide()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                if view.frame.origin.y != .zero {
                    view.frame.origin.y = .zero
                }
            }
            .disposed(by: disposeBag)
    }
}

private extension SignInViewController {
    func presentSignUpView() {
        let useCase = DefaultSignUpUseCase(
            repository: DefaultAuthRepository(
                service: UserService()
            )
        )
        let viewModel = SignUpViewModel(useCase: useCase)
        
        let controller = SignUpViewController(viewModel: viewModel)
        
        useCase.signInUser
            .asDriver(onErrorJustReturn: nil)
            .drive(currentUser)
            .disposed(by: disposeBag)
        
        self.present(controller, animated: true)
    }
    
    func handleLoginResult(_ isSaved: Bool) {
        if isSaved {
            presentMainViewController()
        } else {
            presentLoginFailAlert()
        }
    }
    
    func presentLoginFailAlert() {
        let controller = UIAlertController(
            title: "로그인 실패",
            message: "아이디와 비밀번호를 확인해주세요.",
            preferredStyle: .alert
        )
        controller.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(controller, animated: true)
    }
}

private extension SignInViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [signUpLabel, signUpButton].forEach(signUpStackView.addArrangedSubview)
        [
            logoImageView,
            idFormView,
            passwordFormView,
            signInButton,
            signUpStackView
        ].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(46)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(logoImageView.snp.width)
        }
        
        idFormView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.trailing.equalToSuperview().offset(-44)
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
        }
        
        passwordFormView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.trailing.equalToSuperview().offset(-44)
            $0.top.equalTo(idFormView.snp.bottom).offset(8)
        }
        
        signInButton.snp.makeConstraints {
            $0.leading.equalTo(passwordFormView.snp.leading)
            $0.trailing.equalTo(passwordFormView.snp.trailing)
            $0.top.equalTo(passwordFormView.snp.bottom).offset(28)
        }
        
        signUpStackView.snp.makeConstraints {
            $0.centerX.equalTo(signInButton)
            $0.top.equalTo(signInButton.snp.bottom).offset(24)
        }
    }
}
