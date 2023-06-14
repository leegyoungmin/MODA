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
    
    var dateDescription: String {
        return "\(createdYear)년 \(createdMonth)월 \(createdDay)일"
    }
}
