//
//  SignUpUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import RxRelay

protocol SignUpUseCase {
    var id: BehaviorSubject<String> { get set }
    var email: BehaviorSubject<String> { get set }
    var password: BehaviorSubject<String> { get set }
    var signInUser: PublishSubject<User?> { get set }
    
    func signUp()
}
