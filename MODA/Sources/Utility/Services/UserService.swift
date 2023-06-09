//
//  UserService.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol UserServicing: AnyObject {
    func saveInstallation(with body: [String: Any])
}

final class UserService: UserServicing {
    func saveInstallation(with body: [String: Any]) {
        let api = API.saveInstallation(body: body)
        DefaultNetworkService().request(to: api)
            .subscribe()
            .dispose()
    }
}

private extension UserService {
    enum API {
        case saveInstallation(body: [String: Any])
    }
}

extension UserService.API: APIType {
    var baseURL: String {
        switch self {
        case .saveInstallation:
            return "https://parseapi.back4app.com"
        }
    }
    
    var method: String {
        switch self {
        case .saveInstallation:
            return "POST"
        }
    }
    
    var path: String {
        switch self {
        case .saveInstallation:
            return "/parse/installations"
        }
    }
    
    var params: [String: String] {
        switch self {
        case .saveInstallation:
            return [:]
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .saveInstallation(let body):
            return body
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .saveInstallation:
            return [
                "X-Parse-Application-Id": "T5Idi2coPjEwJ1e30yj8qfgcwvxYHnKlnz4HpyLz",
                "X-Parse-REST-API-Key": "8EFZ0dSEauC938nFNQ3MVV3rvIgJzKlDsLhIxf9M",
                "Content-Type": "application/json"
            ]
        }
    }
}
