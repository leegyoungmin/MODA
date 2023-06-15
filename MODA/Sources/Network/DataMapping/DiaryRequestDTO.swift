//
//  Request.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

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
