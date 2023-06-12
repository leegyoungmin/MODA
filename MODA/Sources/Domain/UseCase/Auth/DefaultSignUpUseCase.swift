//
//  DefaultSignUpUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import RxRelay

final class DefaultSignUpUseCase: SignUpUseCase {
    var id = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var email = BehaviorSubject<String>(value: "")
    var signInToken = PublishSubject<String>()
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func signUp() {
        guard let id = try? id.value(),
              let email = try? email.value(),
              let password = try? password.value() else {
            self.signInToken.on(.error(NetworkError.unknownError))
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
                    .map(\.sessionToken)
            }
            .bind(to: signInToken)
            .disposed(by: disposeBag)
    }
}
