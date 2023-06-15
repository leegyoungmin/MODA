//
//  SavedDiaryViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class SavedDiaryViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
    }
    
    struct Output {
        var likeDiaries: Observable<[Diary]>
    }
    
    private let useCase: SavedDiaryUseCase
    var disposeBag = DisposeBag()
    
    init(useCase: SavedDiaryUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.useCase.loadLikeDiaries()
            }
            .disposed(by: disposeBag)
        
        return Output(
            likeDiaries: useCase.savedDiaries
        )
    }
}
