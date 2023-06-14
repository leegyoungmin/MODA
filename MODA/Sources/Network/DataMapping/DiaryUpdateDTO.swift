//
//  DiaryUpdateDTO.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

struct DiaryUpdateDTO: Codable {
    let content: String
    let condition: Int
    let isLike: Bool?
}
