//
//  Diary.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct Diary {
    enum Condition: Int {
        case good
        case normal
        case bad
    }
    
    let meta: DiaryMeta
    let condition: Condition
    let content: String
}

struct DiaryMeta {
    let createdDate: Date
    let issuedDate: Date
    var isSaved: Bool = false
}

extension Diary {
    static let mockDatas: [Self] = Array(repeating: Self.mockData, count: 10)
    static let mockData: Self = .init(
        meta: DiaryMeta.mockData,
        condition: .bad,
        content: """
        미인을 싶이 우리는 힘차게 황금시대의 봄바람이다. 석가는 평화스러운 뼈 청춘의 거선의 우리의 할지니, 우리는 것이 사막이다.

        착목한는 같으며, 날카로우나 뿐이다. 찾아다녀도, 이상은 살았으며, 곧 따뜻한 보라.
인간이 넣는 노년에게서 무엇이 불어 어디 창공에 보배를 그리하였는가?
별과 되려니와, 그들은 그들에게 찾아 아니더면, 착목한는 그들의 청춘에서만 있는가?

        피가 얼마나 우리 밥을 없으면, 길을 반짝이는 사막이다. 우리 품고 목숨을 끝까지 황금시대다.

        돋고, 커다란 착목한는 위하여, 주는 할지니, 힘차게 지혜는 없는 부패뿐이다. 예가 가지에 품으며, 어디 날카로우나 희망의 많이 것이다.
 인간은 이것을 풀이 트고, 우리 품에 불러 반짝이는 수 있는가? 착목한는 보이는 인생을 주며, 그들의 풀이 살 없으면 있다.

        그림자는 위하여, 얼음이 것이다. 그러므로 무엇을 이상이 예수는 황금시대를 듣는다.

        사람은 살 눈이 청춘 더운지라 목숨을 같이, 설산에서 인생의 것이다. 끝에 그것은 이상은 듣기만 전인 피는 심장의 얼음과 교향악이다.

        몸이 열락의 인간의 청춘의 사는가 인도하겠다는 밝은 얼음에 오아이스도 끓는다. 옷을 품으며, 이성은 청춘 웅대한 위하여서. 주는 되는 속잎나고, 끓는다.

        남는 길지 어디 밥을 천하를 두기 있다. 생의 놀이 끓는 그들의 어디 꽃이 바이며, 곳으로 같은 보라.
"""
    )
}

extension DiaryMeta {
    static let mockData: Self = .init(
        createdDate: Date().addingTimeInterval(TimeInterval(-86400 * Int.random(in: 1...10))),
        issuedDate: Date()
    )
}
