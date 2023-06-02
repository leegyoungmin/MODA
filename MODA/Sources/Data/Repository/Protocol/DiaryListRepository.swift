//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryListRepository {
    var diaries: BehaviorSubject<[Diary]> { get }
    
    func fetchAllDiaries(_ token: String)
    func fetchSearchDiaries(_ token: String, query: String)
    func removeDiaries(objectId: String, token: String)
}
