//
//  SavedDiaryViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class SavedDiaryViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let useCase: SavedDiaryUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SavedDiaryUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
