//
//  UserRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol UserRepository {
    func saveInstallation(_ body: [String: Any])
}
