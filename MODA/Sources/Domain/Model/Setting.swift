//
//  Setting.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct SettingSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    var content: String
}

extension SettingSection {
    static func generateSettings() -> [SettingSection] {
        let hour = UserDefaults.standard.integer(forKey: "notificationHour")
        let minute = UserDefaults.standard.integer(forKey: "notificationMinute")
        
        let description = String(format: "%02d", hour) + ":" + String(format: "%02d", minute)
        
        return [
            .init(title: "alert_setting"~, options: [
                .init(title: "alert_time"~, content: description)
            ]),
            .init(title: "service_center"~, options: [
                .init(title: "send_comment"~, content: ""),
                .init(title: "send_star"~, content: ""),
                .init(title: "policy_title"~, content: "")
            ])
        ]
    }
}
