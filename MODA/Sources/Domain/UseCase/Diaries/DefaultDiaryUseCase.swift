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
    var removeSuccess = PublishSubject<Void>()
    
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(diaryRepository: DiaryRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func loadAllDiaries(option: [String: String] = [:]) {
        guard let month = try? selectedMonth.value(),
              let year = try? selectedYear.value() else { return }
        
        let query = "\"createdMonth\": \(month), \"createdYear\": \(year)"
        
        self.diaryRepository.fetchSearchDiaries(query: query, options: option)
            .subscribe { [weak self] diaries in
                self?.diaries.on(.next(diaries))
            }
            .disposed(by: disposeBag)
    }
    
    func deleteItem(with diary: Diary) {
        self.diaryRepository.removeDiary(id: diary.id)
            .bind(to: removeSuccess)
            .disposed(by: disposeBag)
    }
}
