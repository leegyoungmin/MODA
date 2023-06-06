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
    
    func fetchAllDiaries(_ token: String) {
        diaryService.loadDiaries(with: token)
            .map { $0.results }
            .subscribe { [weak self] diaries in
                guard let self = self else { return }
                self.diaries.onNext(diaries)
            }
            .disposed(by: disposeBag)
    }
    
    func fetchSearchDiaries(_ token: String, query: String) -> Observable<[Diary]> {
        return diaryService.searchDiaries(with: token, query: query)
            .map { $0.results }
    }
    
    func createNewDiary(_ token: String, diary: [String: Any]?) -> Observable<Void> {
        return diaryService.createNewDiary(with: token, diary: diary)
    }
    
    func updateDiary(_ token: String, id: String, diary: [String: Any]?) -> Observable<Void> {
        return diaryService.updateDiary(with: token, to: id, diary: diary)
    }
    
    func removeDiaries(objectId: String, token: String) { }
//    func removeDiaries(objectId: String, token: String) {
//        diaryService.deleteDiary(with: token, to: objectId)
//            .subscribe { [weak self] _ in
//                self?.fetchAllDiaries(token)
//            }
//            .disposed(by: disposeBag)
//    }
}
