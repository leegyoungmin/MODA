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
    var diaryContent = BehaviorSubject<String>(value: "")
    var diaryCondition = BehaviorSubject<Diary.Condition?>(value: nil)
    var diaryLike = BehaviorSubject<Bool>(value: false)
    var removeDiary = PublishSubject<Void>()
    
    private let repository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    init(id: String, repository: DiaryRepository) {
        self.selectedId = id
        self.repository = repository
    }
    
    func fetchCurrentDiary() -> Observable<Diary> {
        let query = "\"objectId\":\"\(selectedId)\""
        
        return repository.fetchSearchDiaries(query: query, options: [:])
            .compactMap(\.first)
            .do(onNext: { [weak self] diary in
                guard let self = self else { return }
                
                self.currentDiary.onNext(diary)
                self.diaryDate.onNext(diary.createdDate)
                self.diaryContent.onNext(diary.content)
                self.diaryCondition.onNext(diary.condition)
                self.diaryLike.onNext(diary.isLike)
            })
    }
    
    func updateCurrentDiary() -> Observable<Void> {
        guard let content = try? diaryContent.value(),
              let condition = try? diaryCondition.value(),
              let like = try? diaryLike.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        return repository.updateDiary(
            id: selectedId,
            content: content,
            condition: condition.rawValue,
            isLike: like
        )
        .catchAndReturn(())
    }
    
    func deleteCurrentDiary() -> Observable<Void> {
        return repository.removeDiary(id: selectedId)
    }
    
    func toggleLike() -> Observable<Void> {
        guard let content = try? diaryContent.value(),
              let condition = try? diaryCondition.value(),
              let like = try? diaryLike.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        return repository.updateDiary(
            id: selectedId,
            content: content,
            condition: condition.rawValue,
            isLike: !like
        )
    }
}
