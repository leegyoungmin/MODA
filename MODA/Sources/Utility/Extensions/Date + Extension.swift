//
//  Date + Extension.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Date {
    static let formatter = DateFormatter()
    
    func toString(_ format: String) -> String {
        let formatter = Self.formatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func toInt(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    func isEqual(rhs: Self) -> Bool {
        let lComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let rComponents = Calendar.current.dateComponents([.year, .month, .day], from: rhs)
        
        let equalYear = (lComponents.year == rComponents.year)
        let equalMonth = (lComponents.month == rComponents.month)
        let equalDay = (lComponents.day == rComponents.day)
        
        return equalYear && equalMonth && equalDay
    }
}
