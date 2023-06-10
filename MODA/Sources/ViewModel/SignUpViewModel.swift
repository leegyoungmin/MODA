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
        
    }
    
    private var useCase: SignUpUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SignUpUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
