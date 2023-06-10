//
//  AuthRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol AuthRepository: AnyObject {
    func signUp(to user: User) -> Observable<String>
}
