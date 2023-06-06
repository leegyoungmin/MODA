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
    
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(diaryRepository: DiaryRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func loadAllDiaries(_ token: String) {
        guard let month = try? selectedMonth.value(),
              let year = try? selectedYear.value() else { return }
        
        let query = "{\"createdMonth\":\(month),\"createdYear\":\(year)}"
        
        self.diaryRepository.fetchSearchDiaries(token, query: query)
            .subscribe { [weak self] diaries in
                self?.diaries.on(.next(diaries))
            }
            .disposed(by: disposeBag)
    }
}
