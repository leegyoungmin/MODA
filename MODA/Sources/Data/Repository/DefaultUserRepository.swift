//
//  DefaultUserRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultUserRepository: UserRepository {
    private let service: UserServicing
    
    init(service: UserServicing) {
        self.service = service
    }
    
    func saveInstallation(_ body: [String: Any]) {
        service.saveInstallation(with: body)
    }
}
