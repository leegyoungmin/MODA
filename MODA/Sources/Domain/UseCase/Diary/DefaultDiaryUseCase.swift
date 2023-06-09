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
    
    func toggleLike(to newDiary: Diary) -> Observable<Void> {
        return diaryRepository.updateDiary(
            id: newDiary.id,
            content: newDiary.content,
            condition: newDiary.condition.rawValue,
            isLike: newDiary.isLike
        )
    }
    
    func deleteItem(with diary: Diary) -> Observable<Void> {
        return self.diaryRepository.removeDiary(id: diary.id)
    }
}
