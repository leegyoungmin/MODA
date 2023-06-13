//
//  Diary.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct Diaries: Codable {
    let results: [Diary]
}

struct Diary: Codable {
    enum Condition: Int, Codable {
        case good = 1
        case normal
        case bad
        
        var description: String {
            switch self {
            case .good:
                return "😃"
            case .normal:
                return "😑"
            case .bad:
                return "😞"
            }
        }
    }
    
    let id: String
    let content: String
    let condition: Condition
    let user: UserPointer
    let createdDate: Date
    let issuedDate: Date
    let createdYear: Int
    let createdMonth: Int
    let createdDay: Int
    var isLike: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case content
        case condition
        case user = "createdUser"
        case createdDate = "createdAt"
        case issuedDate = "updatedAt"
        case createdYear, createdMonth, createdDay
        case isLike
    }
}

struct DiaryRequestDTO: Codable {
    let content: String
    let condition: Int
    let createdUser: UserPointer
    let createdYear: Int
    let createdMonth: Int
    let createdDay: Int
    
    init(content: String, condition: Int, userId: String) {
        self.content = content
        self.condition = condition
        self.createdUser = UserPointer(id: userId)
        self.createdYear = Date().toInt(.year)
        self.createdMonth = Date().toInt(.month)
        self.createdDay = Date().toInt(.day)
    }
}

struct DiaryUpdateDTO: Codable {
    let content: String
    let condition: Int
    let isLike: Bool?
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
