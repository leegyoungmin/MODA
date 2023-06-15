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
    
    func login() {
        guard let id = try? id.value(),
              let password = try? password.value() else {
            isSaved.onNext(false)
            return
        }
        
        repository.signIn(id: id, password: password)
            .asDriver(onErrorJustReturn: User.empty)
            .drive { [weak self] user in
                guard let self = self else {
                    self?.isSaved.onNext(false)
                    return
                }
                
                if user.sessionToken.isEmpty {
                    isSaved.onNext(false)
                    return
                }
                
                if let data = try? JSONEncoder().encode(user) {
                    UserDefaults.standard.set(data, forKey: "currentUser")
                    isSaved.onNext(true)
                    return
                }
                
                isSaved.onNext(false)
            }
            .disposed(by: disposeBag)
    }
}
