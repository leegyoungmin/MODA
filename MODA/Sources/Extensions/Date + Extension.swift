//
//  Date + Extension.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func day() -> String {
        let formatter = Self.formatter
        formatter.dateFormat = "dd일"
        return formatter.string(from: self)
    }
}
