//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryRepository {
    func fetchAllDiaries(_ token: String)
    func fetchSearchDiaries(_ token: String, query: String) -> Observable<[Diary]>
    func createNewDiary(_ token: String, diary: [String: Any]?) -> Observable<Void>
    func updateDiary(_ token: String, id: String, diary: [String: Any]?) -> Observable<Void>
    func removeDiaries(objectId: String, token: String)
}
