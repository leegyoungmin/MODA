//
//  SignUpUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol SignUpUseCase {
    var id: BehaviorSubject<String> { get set }
    var email: BehaviorSubject<String> { get set }
    var password: BehaviorSubject<String> { get set }
    
    func signUp() -> Observable<String>
}
