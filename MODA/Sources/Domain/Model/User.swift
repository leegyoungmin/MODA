//
//  User.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct User: Codable {
    let identifier: String
    let userName: String?
    let createdDate: Date
    let updatedDate: Date?
    let sessionToken: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "objectId"
        case userName = "username"
        case createdDate = "createdAt"
        case updatedDate = "updatedAt"
        case sessionToken
    }
    
    static let empty: Self = .init(
        identifier: "",
        userName: nil,
        createdDate: Date(),
        updatedDate: nil,
        sessionToken: ""
    )
}

struct UserPointer: Codable {
    let id: String
    let type: String = "Pointer"
    let className: String = "_User"
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case type = "__type"
        case className
    }
    
    var query: String {
        return "\"createdUser\":{\"__type\":\"\(type)\",\"className\":\"\(className)\",\"objectId\":\"\(id)\"}"
    }
}
