//
//  DefaultDiaryWriteUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DefaultDiaryWriteUseCase: DiaryWriteUseCase {
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    var id = BehaviorSubject<String>(value: "")
    var content = BehaviorSubject<String>(value: "")
    var condition = BehaviorSubject<Int>(value: -1)
    var saveState = BehaviorSubject<DiaryWriteViewModel.SaveState>(value: .none)
    var isLike = BehaviorSubject<Bool>(value: false)
    var isFirstWrite = BehaviorSubject<Bool>(value: true)
    
    init(diaryRepository: DiaryRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func loadTodayDiary() {
        let date = Date()
        let query = """
\"createdMonth\":\(date.toInt(.month)),
\"createdYear\":\(date.toInt(.year)),
\"createdDay\":\(date.toInt(.day))
"""
        self.saveState.onNext(.loading)
        
        diaryRepository.fetchSearchDiaries(query: query, options: [:])
            .catch { [weak self] _ in
                guard let self = self else { return .just([]) }
                
                self.saveState.onNext(.none)
                return .just([])
            }
            .map(\.first)
            .subscribe { [weak self] diary in
                guard let self = self,
                      let element = diary.element else { return }
                
                if let diary = element {
                    id.onNext(diary.id)
                    content.onNext(diary.content)
                    condition.onNext(diary.condition.rawValue)
                    isLike.onNext(diary.isLike)
                    isFirstWrite.onNext(false)
                } else {
                    isFirstWrite.onNext(true)
                }
                
                self.saveState.onNext(.success)
            }
            .disposed(by: disposeBag)
    }
    
    func postDiary() -> Observable<Void> {
        guard let content = try? content.value(),
              let condition = try? condition.value(),
              let isFirstWrite = try? isFirstWrite.value(),
              let id = try? id.value(),
              let isLike = try? isLike.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        return isFirstWrite ? createNewDiary(
            content: content,
            condition: condition
        ) : updateExistDiary(
            id: id,
            content: content,
            condition: condition,
            isLike: isLike
        )
    }
    
    private func createNewDiary(
        content: String,
        condition: Int
    ) -> Observable<Void> {
        return diaryRepository.createNewDiary(
            content: content,
            condition: condition
        )
    }
    
    private func updateExistDiary(
        id: String,
        content: String,
        condition: Int,
        isLike: Bool
    ) -> Observable<Void> {
        return diaryRepository.updateDiary(
            id: id,
            content: content,
            condition: condition,
            isLike: isLike
        )
    }
}
