//
//  DefaultDiaryWriteUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultDiaryWriteUseCase: DiaryWriteUseCase {
    private let diaryRepository: DiaryRepository
    private let disposeBag = DisposeBag()
    
    var content = BehaviorSubject<String>(value: "")
    var condition = BehaviorSubject<Int>(value: -1)
    var saveState = BehaviorSubject<Bool>(value: false)
    
    init(diaryRepository: DiaryRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func createNewDiary(token: String, with userId: String) -> Observable<Void> {
        guard let content = try? content.value(),
              let condition = try? condition.value() else {
            return Observable.error(NetworkError.unknownError)
        }
        
        let diaryRequestData = DiaryRequestDTO(
            content: content,
            condition: condition,
            userId: userId
        ).toDictionary
        
        return diaryRepository.createNewDiary(token, diary: diaryRequestData)
    }
}
