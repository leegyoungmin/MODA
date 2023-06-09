//
//  SignInViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    private let idFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "아이디")
        return formView
    }()
    
    private let passwordFormView: AuthFormStackView = {
        let formView = AuthFormStackView(title: "비밀번호")
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
    
    private let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = SignInViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindings()
    }
}

// MARK: - 로그인 임시 코드
private extension SignInViewController {
    
    func presentMainViewController() {
        DispatchQueue.main.async {
            guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                  let window = delegate.window else {
                return
            }
            
            window.rootViewController = TabViewController()
        }
    }
}

private extension SignInViewController {
    func bindings() {
        signInButton.rx.tap
            .bind { [weak self] _ in
            }
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                
                let controller = SignUpViewController()
                self.present(controller, animated: true)
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
        [signUpLabel, signUpButton].forEach(signUpStackView.addArrangedSubview)
        [idFormView, passwordFormView, signInButton, signUpStackView].forEach(view.addSubview)
    }
    
    func makeConstraints() {
        
        idFormView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(44)
            $0.trailing.equalToSuperview().offset(-44)
            $0.centerY.equalToSuperview().offset(-50)
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
