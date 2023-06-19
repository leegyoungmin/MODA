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
    var signUpUser = PublishSubject<User>()
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp() -> Observable<User> {
        guard let id = try? id.value(),
              let email = try? email.value(),
              let password = try? password.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        let bodyDictionary: [String: Any] = [
            "username": id,
            "password": password,
            "email": email
        ]
        
        return repository.signUp(body: bodyDictionary)
            .flatMap { _ in
                return self.repository.signIn(id: id, password: password)
            }
            .catchAndReturn(User.empty)
    }
}
