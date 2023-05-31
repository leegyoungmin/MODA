//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryListRepository {
    var diaries: BehaviorSubject<[Diary]> { get }
    
    func fetchDiaries(_ token: String)
    func removeDiaries(objectId: String, token: String)
}
