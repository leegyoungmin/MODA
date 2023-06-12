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
    
    func fetchAllDiaries() {
        diaryService.loadDiaries()
            .map { $0.results }
            .subscribe { [weak self] diaries in
                guard let self = self else { return }
                self.diaries.onNext(diaries)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchSearchDiaries(query: String) -> Observable<[Diary]> {
        return diaryService.searchDiaries(query: query)
            .map { $0.results }
    }
    
    func createNewDiary(diary: [String: Any]?) -> Observable<Void> {
        return diaryService.createNewDiary(diary: diary)
    }
    
    func updateDiary(id: String, diary: [String: Any]?) -> Observable<Void> {
        return diaryService.updateDiary(to: id, diary: diary)
    }
    
    func removeDiary(id: String) -> Observable<Void> {
        return diaryService.removeDiary(id: id)
    }
}
