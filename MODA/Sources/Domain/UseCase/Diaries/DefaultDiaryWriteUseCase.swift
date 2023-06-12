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
    var isFirstWrite = BehaviorSubject<Bool>(value: true)
    
    init(diaryRepository: DiaryRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func loadTodayDiary(_ token: String) {
        let date = Date()
        let query = """
{\"createdMonth\":\(date.toInt(.month)),
\"createdYear\":\(date.toInt(.year)),
\"createdDay\":\(date.toInt(.day))
}
"""
        self.saveState.onNext(.loading)
        
        diaryRepository.fetchSearchDiaries(token, query: query)
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
                    isFirstWrite.onNext(false)
                } else {
                    isFirstWrite.onNext(true)
                }
                
                self.saveState.onNext(.success)
            }
            .disposed(by: disposeBag)
    }
    
    func postDiary(token: String, with userId: String) -> Observable<Void> {
        guard let content = try? content.value(),
              let condition = try? condition.value(),
              let isFirstWrite = try? isFirstWrite.value(),
              let id = try? id.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        return isFirstWrite ? createNewDiary(
            token: token,
            userId: "Vz9lsMuuKd",
            content: content,
            condition: condition
        ) : updateExistDiary(
            token: token,
            diaryId: id,
            content: content,
            condition: condition
        )
    }
    
    private func createNewDiary(
        token: String,
        userId: String,
        content: String,
        condition: Int
    ) -> Observable<Void> {
        let requestData = DiaryRequestDTO(content: content, condition: condition, userId: userId)
        return diaryRepository.createNewDiary(token, diary: requestData.toDictionary)
    }
    
    private func updateExistDiary(
        token: String,
        diaryId: String,
        content: String,
        condition: Int
    ) -> Observable<Void> {
        let requestData = DiaryUpdateDTO(content: content, condition: condition)
        return diaryRepository.updateDiary(token, id: diaryId, diary: requestData.toDictionary)
    }
}
