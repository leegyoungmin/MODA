//
//  JsonDecoder + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension JSONDecoder {
    func ISODecoder() -> Self {
        let formatter = ISO8601DateFormatter().setOptions(
            .withFullDate, .withFullTime, .withFractionalSeconds
        )
        self.dateDecodingStrategy = .custom { dateDecoder in
            let container = try dateDecoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Can not Convert \(dateString)"
            )
        }
        
        return self
    }
}
