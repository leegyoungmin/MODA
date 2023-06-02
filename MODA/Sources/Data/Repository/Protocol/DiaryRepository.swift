//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryRepository {
    func fetchAllDiaries(_ token: String)
    func fetchSearchDiaries(_ token: String, query: String) -> Observable<[Diary]>
    func removeDiaries(objectId: String, token: String)
}
