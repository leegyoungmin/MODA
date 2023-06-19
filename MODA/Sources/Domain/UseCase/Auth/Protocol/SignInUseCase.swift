//
//  SignInUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol SignInUseCase: AnyObject {
    var id: BehaviorSubject<String> { get set }
    var password: BehaviorSubject<String> { get set }
    var isSaved: PublishSubject<Bool> { get set }
    
    func fetchUser() -> Observable<User>
    func login() -> Observable<User>
}
