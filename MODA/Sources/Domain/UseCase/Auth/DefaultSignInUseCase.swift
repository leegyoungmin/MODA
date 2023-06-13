//
//  DefaultSignInUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultSignInUseCase: SignInUseCase {
    var id = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var user = BehaviorSubject<User?>(value: nil)
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func fetchUser() {
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data,
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.user.onNext(user)
        }
    }
    
    func login() {
        guard let id = try? id.value(),
              let password = try? password.value() else {
            return
        }
        
        repository.signIn(id: id, password: password)
            .bind(to: user)
            .disposed(by: disposeBag)
    }

}
