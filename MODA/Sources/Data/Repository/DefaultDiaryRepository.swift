//
//  DefaultDiaryRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultDiaryRepository: DiaryRepository {
    private(set) var diaries = BehaviorSubject<[Diary]>(value: [])
    private(set) var selectedMonth: BehaviorSubject<Int>
    
    private var disposeBag = DisposeBag()
    private let diaryService: DiaryServicing
    
    init(diaryService: DiaryServicing) {
        self.diaryService = diaryService
        
        let current = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: current)
        
        self.selectedMonth = BehaviorSubject(value: month)
    }
    
    func fetchSearchDiaries(query: String, options: [String: String] = [:]) -> Observable<[Diary]> {
        return diaryService.searchDiaries(query: query, option: options)
            .map { $0.results }
    }
    
    func createNewDiary(content: String, condition: Int) -> Observable<Void> {
        return diaryService.createNewDiary(content: content, condition: condition)
    }
    
    func updateDiary(id: String, content: String, condition: Int, isLike: Bool) -> Observable<Void> {
        return diaryService.updateDiary(to: id, content: content, condition: condition, isLike: isLike)
    }
    
    func removeDiary(id: String) -> Observable<Void> {
        return diaryService.removeDiary(id: id)
    }
}
