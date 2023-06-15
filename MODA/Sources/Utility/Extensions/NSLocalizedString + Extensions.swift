//
//  NSLocalizedString + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
