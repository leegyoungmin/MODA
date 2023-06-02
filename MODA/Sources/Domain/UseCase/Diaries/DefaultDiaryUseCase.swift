//
//  DefaultDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultDiaryListUseCase: DiaryListUseCase {
    var diaries = PublishSubject<[Diary]>()
    var selectedMonth = BehaviorSubject<Int>(value: Date().toInt(.month))
    
    private let diaryListRepository: DiaryListRepository
    private let disposeBag = DisposeBag()
    
    init(diaryListRepository: DiaryListRepository) {
        self.diaryListRepository = diaryListRepository
    }
    
    func loadAllDiaries(_ token: String) {
        guard let month = try? selectedMonth.value() else { return }
        
        let query = "{\"createdMonth\":\(month)}"
        
        self.diaryListRepository.fetchSearchDiaries(token, query: query)
            .subscribe { [weak self] diaries in
                self?.diaries.on(.next(diaries))
            }
            .disposed(by: disposeBag)
    }
}
