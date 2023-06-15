//
//  UserService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol UserServicing: AnyObject {
    func saveInstallation(with body: [String: Any])
    
    func logIn(with body: [String: Any]?) -> Observable<User>
    func createUser(with body: [String: Any]?) -> Observable<User>
}

final class UserService: UserServicing {
    func saveInstallation(with body: [String: Any]) {
        let api = API.saveInstallation(body: body)
        DefaultNetworkService().request(to: api)
            .subscribe()
            .dispose()
    }
    
    func logIn(with body: [String: Any]?) -> Observable<User> {
        let api = API.login(body: body)
        return DefaultNetworkService().request(to: api)
    }
    
    func createUser(with body: [String: Any]?) -> Observable<User> {
        let api = API.createUser(body: body)
        return DefaultNetworkService().request(to: api)
    }
}

private extension UserService {
    enum API {
        case saveInstallation(body: [String: Any])
        case login(body: [String: Any]?)
        case createUser(body: [String: Any]?)
    }
}

extension UserService.API: APIType {
    var baseURL: String {
        return "https://parseapi.back4app.com"
    }
    
    var method: String {
        switch self {
        default:
            return "POST"
        }
    }
    
    var path: String {
        switch self {
        case .saveInstallation:
            return "/parse/installations"
        case .createUser:
            return "/users"
        case .login:
            return "/parse/login"
        }
    }
    
    var params: [String: String] {
        switch self {
        default:
            return [:]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .saveInstallation(let body):
            return body
            
        case .createUser(let body):
            return body
            
        case .login(let body):
            return body
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .saveInstallation:
            return [
                "Content-Type": "application/json"
            ]
            
        case .createUser, .login:
            return [
                "X-Parse-Revocable-Session": "1",
                "Content-Type": "application/json"
            ]
        }
    }
}
