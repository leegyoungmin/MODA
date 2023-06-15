//
//  DefaultSavedDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultSavedDiaryUseCase: SavedDiaryUseCase {
    
    var savedDiaries = PublishSubject<[Diary]>()
    
    private let repository: DiaryRepository
    private var disposeBag = DisposeBag()
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
    
    func loadLikeDiaries() {
        let query = "\"isLike\": \(true)"
        let option = ["order": "createdYear, createdMonth, createdDay"]
        
        repository.fetchSearchDiaries(query: query, options: option)
            .bind(to: savedDiaries)
            .disposed(by: disposeBag)
    }
}
