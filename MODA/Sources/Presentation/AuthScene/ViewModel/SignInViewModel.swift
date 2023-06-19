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
        var fetchedUser: Observable<User>
        var currentUser: Observable<User>
    }
    
    let useCase: SignInUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SignInUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.id
            .filter { $0.isEmpty == false }
            .bind(to: useCase.id)
            .disposed(by: disposeBag)
        
        input.password
            .filter { $0.isEmpty == false }
            .bind(to: useCase.password)
            .disposed(by: disposeBag)
        
        let fetchedUser = input.viewWillAppear
            .flatMap {
                self.useCase.fetchUser()
                    .catchAndReturn(User.empty)
            }
        
        let currentUser = input.didTapLoginButton
            .flatMapLatest { [unowned self] _ -> Observable<User> in
                return self.useCase.login()
            }
        
        return Output(
            fetchedUser: fetchedUser,
            currentUser: currentUser
        )
    }
}
