//
//  DefaultAuthRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultAuthRepository: AuthRepository {
    private let service: UserServicing
    
    init(service: UserServicing) {
        self.service = service
    }
    
    func signIn(id: String, password: String) -> Observable<User> {
        let body: [String: Any] = [
            "username": id,
            "password": password
        ]
        return service.logIn(with: body)
    }
    
    func signUp(body: [String: Any]) -> Observable<String> {
        return service.createUser(with: body)
            .map(\.sessionToken)
    }
}
