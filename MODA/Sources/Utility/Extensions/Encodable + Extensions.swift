//
//  Encodable + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension Encodable {
    var toDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else {
            return nil
        }
        
        return dictionary
    }
}
