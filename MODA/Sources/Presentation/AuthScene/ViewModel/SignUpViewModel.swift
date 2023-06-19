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
        var passwordLength: Observable<Bool>
        var passwordValid: Observable<Bool>
        var signUpValid: Observable<Bool>
        var signUpUser: Observable<User>
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
        
        let passwords = Observable.combineLatest(input.password, input.passwordConfirm)
        
        let passwordValid = passwords.map { ($0 == $1) }
        
        let passwordLengthValid = input.password.filter { $0.isEmpty == false }
            .map { self.validatePassword(to: $0) }
        
        let idValid = useCase.id.map { $0.isEmpty == false }
        let emailValid = useCase.email
            .map { self.validEmail(to: $0) && ($0.isEmpty == false) }
        
        let signUpEnable = Observable.combineLatest(
            idValid,
            emailValid,
            passwordValid,
            resultSelector: { $0 && $1 && $2 }
        )
        
        let signUpUser = input.didTapSignUpButton
            .flatMapLatest { _ -> Observable<User> in
                return self.useCase.signUp()
            }
        
        return Output(
            emailValid: emailValid,
            passwordLength: passwordLengthValid,
            passwordValid: passwordValid,
            signUpValid: signUpEnable,
            signUpUser: signUpUser
        )
    }
}

extension SignUpViewModel {
    func validEmail(to email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    func validatePassword(to password: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
//        print(predicate.evaluate(with: password))
        return predicate.evaluate(with: password)
    }
}
