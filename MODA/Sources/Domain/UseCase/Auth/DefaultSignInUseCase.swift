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
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func fetchUser() -> Observable<User> {
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data,
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return Observable.of(user)
        } else {
            return Observable.error(NetworkError.unknownError)
        }
    }
    
    func login() -> Observable<User> {
        guard let id = try? id.value(), let password = try? password.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        return repository.signIn(id: id, password: password)
            .do(onNext: saveDefaults)
            .catchAndReturn(User.empty)
    }
}

private extension DefaultSignInUseCase {
    func saveDefaults(with user: User) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "currentUser")
    }
}
