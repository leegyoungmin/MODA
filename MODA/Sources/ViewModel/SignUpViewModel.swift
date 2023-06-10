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
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
