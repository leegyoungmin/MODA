//
//  DefaultDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultDiaryListUseCase: DiaryListUseCase {
    var diaries = PublishSubject<[Diary]>()
    var selectedYear = BehaviorSubject<Int>(value: Date().toInt(.year))
    var selectedMonth = BehaviorSubject<Int>(value: Date().toInt(.month))
    
    private let diaryListRepository: DiaryListRepository
    private let disposeBag = DisposeBag()
    
    init(diaryListRepository: DiaryListRepository) {
        self.diaryListRepository = diaryListRepository
    }
    
    func loadAllDiaries(_ token: String) {
        guard let month = try? selectedMonth.value(),
              let year = try? selectedYear.value() else { return }
        print(year, month)
        let query = "{\"createdMonth\":\(month),\"createdYear\":\(year)}"
        
        self.diaryListRepository.fetchSearchDiaries(token, query: query)
            .subscribe { [weak self] diaries in
                self?.diaries.on(.next(diaries))
            }
            .disposed(by: disposeBag)
    }
}
