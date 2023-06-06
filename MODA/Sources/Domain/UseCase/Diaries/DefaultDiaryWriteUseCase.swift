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
    var saveState = BehaviorSubject<Bool>(value: false)
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
        diaryRepository.fetchSearchDiaries(token, query: query)
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
            }
            .disposed(by: disposeBag)
    }
    
    func createNewDiary(token: String, with userId: String) -> Observable<Void> {
        guard let content = try? content.value(),
              let condition = try? condition.value(),
              let isFirstWrite = try? isFirstWrite.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        if isFirstWrite {
            let diaryRequestData = DiaryRequestDTO(
                content: content,
                condition: condition,
                userId: userId
            ).toDictionary
            
            return diaryRepository.createNewDiary(token, diary: diaryRequestData)
        } else {
            guard let id = try? id.value() else { return Observable.error(NetworkError.unknownError) }
            
            let updateRequestData = DiaryUpdateDTO(
                content: content,
                condition: condition
            ).toDictionary
            
            return diaryRepository.updateDiary(
                "r:71be8a7f09796ced27e1242288a142b6",
                id: id,
                diary: updateRequestData
            )
        }
    }
}
