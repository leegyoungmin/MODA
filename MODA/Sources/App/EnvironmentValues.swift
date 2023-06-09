//
//  EnvironmentValues.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

final class EnvironmentValues {
    static let shared = EnvironmentValues()
    
    var apiKey: String = ""
    var applicationId: String = ""
    
    private init() {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API-KEY") as? String {
            self.apiKey = apiKey
        }
        
        if let applicationId = Bundle.main.object(forInfoDictionaryKey: "APP-ID") as? String {
            self.applicationId = applicationId
        }
    }
}
