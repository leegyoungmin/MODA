//
//  Setting.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

struct SettingSection {
    let title: String
    let options: [SettingOption]
}

struct SettingOption {
    let title: String
    let content: String
}

extension SettingSection {
    static let defaultSettings: [SettingSection] = [
        .init(title: "알림 설정", options: [
            .init(title: "알림 시간", content: "09:00")
        ]),
        .init(title: "고객 센터", options: [
            .init(title: "의견보내기", content: ""),
            .init(title: "별점남기기", content: ""),
            .init(title: "개인정보처리방침", content: "")
        ])
    ]
}
