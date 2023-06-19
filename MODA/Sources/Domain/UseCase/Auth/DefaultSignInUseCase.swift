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
    var isSaved = PublishSubject<Bool>()
    
    private let repository: AuthRepository
    private var disposeBag = DisposeBag()
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func fetchUser() {
        if let data = UserDefaults.standard.object(forKey: "currentUser") as? Data,
           let _ = try? JSONDecoder().decode(User.self, from: data) {
            self.isSaved.onNext(true)
        }
    }
    
    func login() -> Observable<User> {
        guard let id = try? id.value(), let password = try? password.value() else {
            isSaved.onNext(false)
            return Observable.error(NetworkError.unknownError)
        }
        
        return repository.signIn(id: id, password: password)
            .catchAndReturn(User.empty)
    }
}
