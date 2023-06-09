//
//  SignInViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class SignInViewModel: ViewModel {
    struct Input {
        var didTapLoginButton: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.didTapLoginButton
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                print("Login Button Tapped -> Login Success")
            }
            .disposed(by: disposeBag)
        return Output()
    }
}
