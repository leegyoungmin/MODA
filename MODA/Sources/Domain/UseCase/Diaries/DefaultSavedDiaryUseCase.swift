//
//  DefaultSavedDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultSavedDiaryUseCase: SavedDiaryUseCase {
    
    var savedDiaries = PublishSubject<[Diary]>()
    
    private let repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    func loadLikeDiaries() {
        
//        repository.fetchSearchDiaries(query: <#T##String#>)
    }
}
