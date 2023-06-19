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
    
    func loadAllDiaries(option: [String: String] = [:]) -> Observable<[Diary]> {
        guard let month = try? selectedMonth.value(),
              let year = try? selectedYear.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        let query = "\"createdMonth\": \(month), \"createdYear\": \(year)"
        
        return diaryRepository.fetchSearchDiaries(query: query, options: option)
            .catchAndReturn([])
    }
    
    func updateDiary(diary: Diary) {
        self.diaryRepository.updateDiary(
            id: diary.id,
            content: diary.content,
            condition: diary.condition.rawValue,
            isLike: diary.isLike
        )
        .subscribe { [weak self] _ in
            self?.loadAllDiaries()
        }
        .disposed(by: disposeBag)
    }
    
    func deleteItem(with diary: Diary) {
        self.diaryRepository.removeDiary(id: diary.id)
            .bind(to: removeSuccess)
            .disposed(by: disposeBag)
    }
}
