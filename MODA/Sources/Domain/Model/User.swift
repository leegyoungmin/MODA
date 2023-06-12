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
}
