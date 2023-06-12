//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryRepository {
    func fetchSearchDiaries(query: String) -> Observable<[Diary]>
    func createNewDiary(content: String, condition: Int) -> Observable<Void>
    func updateDiary(id: String, content: String, condition: Int) -> Observable<Void>
    func removeDiary(id: String) -> Observable<Void>
}
