//
//  DefaultSignUpUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import RxRelay
import Foundation

final class DefaultSignUpUseCase: SignUpUseCase {
    var id = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var email = BehaviorSubject<String>(value: "")
    var isSignInSuccess = PublishSubject<Bool>()
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp() {
        guard let id = try? id.value(),
              let email = try? email.value(),
              let password = try? password.value() else {
            self.isSignInSuccess.onNext(false)
            return
        }
        
        let bodyDictionary: [String: Any] = [
            "username": id,
            "password": password,
            "email": email
        ]
        
        repository.signUp(body: bodyDictionary)
            .flatMap { _ in
                return self.repository.signIn(id: id, password: password)
            }
            .asDriver(onErrorJustReturn: User.empty)
            .drive { [weak self] user in
                guard let self = self else { return }
                
                if user.sessionToken.isEmpty {
                    isSignInSuccess.onNext(false)
                    return
                }
                
                if let data = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.set(data, forKey: "currentUser")
                    
                    self.isSignInSuccess.onNext(true)
                }
            }
            .disposed(by: disposeBag)
    }
}
