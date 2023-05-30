//
//  DiaryListViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DiaryListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        var diaries: Observable<[Diary]>
    }
    
    private let diaryRepository: DiaryListRepository
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(diaryRepository: DiaryListRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func transform(input: Input) -> Output {
        let diaries = self.loadDiary()
        
        return Output(diaries: diaries)
    }
    
    func loadDiary() -> Observable<[Diary]> {
        return diaryRepository.fetchDiaries("r:9831913b6e42aa7a7cf46a49e9790da8")
    }
}
