//
//  AuthRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol AuthRepository: AnyObject {
    func signIn(id: String, password: String) -> Observable<Void>
    func signUp(to user: User) -> Observable<String>
}
