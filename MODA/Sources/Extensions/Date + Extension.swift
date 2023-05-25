//
//  Date + Extension.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func month() -> String {
        let formatter = Self.formatter
        formatter.dateFormat = "MM월"
        return formatter.string(from: self)
    }
    
    func day() -> String {
        let formatter = Self.formatter
        formatter.dateFormat = "dd일"
        return formatter.string(from: self)
    }
    
    func year() -> String {
        let formatter = Self.formatter
        formatter.dateFormat = "yyyy년"
        return formatter.string(from: self)
    }
    
    static func nowDescription() -> String {
        let formatter = Self.formatter
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: Date())
    }
}
