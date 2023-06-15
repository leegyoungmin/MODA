//
//  SignInViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation
import RxRelay

final class SignInViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var id: Observable<String>
        var password: Observable<String>
        var didTapLoginButton: Observable<Void>
    }
    
    struct Output {
        var isSaved: Observable<Bool>
    }
    
    let useCase: SignInUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.useCase.fetchUser()
            }
            .disposed(by: disposeBag)
        
        input.id
            .bind(to: useCase.id)
            .disposed(by: disposeBag)
        
        input.password
            .bind(to: useCase.password)
            .disposed(by: disposeBag)
        
        input.didTapLoginButton
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.useCase.login()
            }
            .disposed(by: disposeBag)
        
        return Output(
            isSaved: self.useCase.isSaved
        )
    }
}
