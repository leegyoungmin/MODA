//
//  DateFormatter + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension ISO8601DateFormatter {
    func setOptions(
        _ options: ISO8601DateFormatter.Options...
    ) -> ISO8601DateFormatter {
        options.forEach {
            self.formatOptions.insert($0)
        }
        
        return self
    }
}
