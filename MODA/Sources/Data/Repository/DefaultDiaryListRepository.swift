//
//  DefaultDiaryRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultDiaryListRepository: DiaryListRepository {
    private let diaryService: DiaryServicing
    
    init(diaryService: DiaryServicing) {
        self.diaryService = diaryService
    }
    
    func fetchDiaries(_ token: String) -> Observable<[Diary]> {
        return diaryService.loadDiaries(with: token)
            .map { $0.results }
    }
}
