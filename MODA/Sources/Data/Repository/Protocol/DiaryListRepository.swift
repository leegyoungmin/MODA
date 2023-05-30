//
//  DiaryListRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryListRepository {
    func fetchDiaries(_ token: String) -> Observable<[Diary]>
}
