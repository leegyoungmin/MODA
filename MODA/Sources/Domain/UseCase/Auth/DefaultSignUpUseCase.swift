//
//  DefaultSignUpUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultSignUpUseCase: SignUpUseCase {
    var id = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var email = BehaviorSubject<String>(value: "")
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp() -> Observable<String> {
        guard let id = try? id.value(),
              let email = try? email.value(),
              let password = try? password.value() else {
            return Observable.of("")
        }
        
        let bodyDictionary: [String: Any] = [
            "username": id,
            "password": password,
            "email": email
        ]
        
        return repository.signUp(body: bodyDictionary).asObservable()
    }
}
