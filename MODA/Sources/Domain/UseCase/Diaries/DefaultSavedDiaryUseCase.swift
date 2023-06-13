//
//  DefaultSavedDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultSavedDiaryUseCase: SavedDiaryUseCase {
    
    private let repository: DiaryRepository
    
    init(repository: DiaryRepository) {
        self.repository = repository
    }
}
