//
//  SignUpViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class SignUpViewModel: ViewModel {
    struct Input {
        var id: Observable<String>
        var email: Observable<String>
        var password: Observable<String>
        var passwordConfirm: Observable<String>
    }
    
    struct Output {
        var passwordValid: Observable<Bool>
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
        
        let passwordValid = Observable.combineLatest(input.password, input.passwordConfirm)
            .filter { ($0.0.isEmpty == false) && ($0.1.isEmpty == false) }
            .map { $0 == $1 }
            .debug()
        
        return Output(passwordValid: passwordValid)
    }
}
