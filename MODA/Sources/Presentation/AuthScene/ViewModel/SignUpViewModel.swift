//
//  SignUpViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation
import RxCocoa

final class SignUpViewModel: ViewModel {
    struct Input {
        var id: Observable<String>
        var email: Observable<String>
        var password: Observable<String>
        var passwordConfirm: Observable<String>
        var didTapSignUpButton: Observable<Void>
    }
    
    struct Output {
        var emailValid: Observable<Bool>
        var passwordValid: Observable<Bool>
        var signUpValid: Observable<Bool>
        var signUpSuccess: Observable<Bool>
    }
    
    private var useCase: SignUpUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.id
            .bind(to: useCase.id)
            .disposed(by: disposeBag)
        
        input.password
            .bind(to: useCase.password)
            .disposed(by: disposeBag)
        
        input.email
            .bind(to: useCase.email)
            .disposed(by: disposeBag)
        
        input.didTapSignUpButton
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.useCase.signUp()
            }
            .disposed(by: disposeBag)
        
        let passwordValid = Observable.combineLatest(input.password, input.passwordConfirm)
            .filter { ($0.0.isEmpty == false) && ($0.1.isEmpty == false) }
            .map { $0 == $1 }
        
        let idValid = useCase.id.map { $0.isEmpty == false }
        let emailValid = useCase.email
            .map { self.validEmail(to: $0) && ($0.isEmpty == false) }
        
        let signUpEnable = Observable.combineLatest(
            idValid,
            emailValid,
            passwordValid,
            resultSelector: { $0 && $1 && $2 }
        )
        
        return Output(
            emailValid: emailValid,
            passwordValid: passwordValid,
            signUpValid: signUpEnable,
            signUpSuccess: useCase.isSignInSuccess.asObservable()
        )
    }
}

extension SignUpViewModel {
    func validEmail(to email: String) -> Bool {
        let reg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
        return predicate.evaluate(with: email)
    }
}
