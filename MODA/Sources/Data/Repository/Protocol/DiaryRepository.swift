//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryRepository {
    func fetchAllDiaries()
    func fetchSearchDiaries(query: String) -> Observable<[Diary]>
    func createNewDiary(diary: [String: Any]?) -> Observable<Void>
    func updateDiary(id: String, diary: [String: Any]?) -> Observable<Void>
    func removeDiary(id: String) -> Observable<Void>
}
