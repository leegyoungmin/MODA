//
//  SignInUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol SignInUseCase: AnyObject {
    var id: BehaviorSubject<String> { get set }
    var password: BehaviorSubject<String> { get set }
    var user: BehaviorSubject<User?> { get set }
    
    func login()
}
