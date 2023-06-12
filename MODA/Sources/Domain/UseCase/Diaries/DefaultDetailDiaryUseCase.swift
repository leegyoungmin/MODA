//
//  DefaultDetailDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

final class DefaultDetailDiaryUseCase: DetailDiaryUseCase {
    var selectedId: String
    var currentDiary = BehaviorSubject<Diary?>(value: nil)
    
    var diaryDate = BehaviorSubject<Date?>(value: nil)
    var diaryContent = BehaviorSubject<String?>(value: nil)
    var diaryCondition = BehaviorSubject<Diary.Condition?>(value: nil)
    var removeDiary = PublishSubject<Void>()
    
    private let repository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(id: String, repository: DiaryRepository) {
        self.selectedId = id
        self.repository = repository
    }
    
    func fetchCurrentDiary() {
        let query = "{\"objectId\":\"\(selectedId)\"}"
        
        repository.fetchSearchDiaries(query: query)
            .compactMap(\.first)
            .subscribe { [weak self] diary in
                guard let self = self, let value = diary.element else { return }
                
                self.currentDiary.onNext(value)
                self.diaryDate.onNext(value.createdDate)
                self.diaryContent.onNext(value.content)
                self.diaryCondition.onNext(value.condition)
            }
            .disposed(by: disposeBag)
    }
    
    func updateCurrentDiary() {
        guard let content = try? diaryContent.value(),
              let condition = try? diaryCondition.value() else { return }
        
        let updateData = DiaryUpdateDTO(content: content, condition: condition.rawValue).toDictionary
        
        repository.updateDiary(id: selectedId, diary: updateData)
            .flatMap { [weak self] _ -> Observable<[Diary]> in
                guard let self = self else { return Observable.just([]) }
                return self.repository.fetchSearchDiaries(
                    query: "{\"objectId\":\"\(self.selectedId)\"}"
                )
            }
            .compactMap(\.first)
            .subscribe { [weak self] diary in
                guard let self = self else { return }
                
                self.currentDiary.onNext(diary)
            }
            .disposed(by: disposeBag)
    }
    
    func deleteCurrentDiary() {
        repository.removeDiary(id: selectedId)
            .subscribe { [weak self] event in
                guard let self = self else { return }
                removeDiary.onNext(event)
            }
            .disposed(by: disposeBag)
    }
    
}
