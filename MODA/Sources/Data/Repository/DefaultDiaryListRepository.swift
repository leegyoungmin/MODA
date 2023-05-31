//
//  DefaultDiaryRepository.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DefaultDiaryListRepository: DiaryListRepository {
    private(set) var diaries = BehaviorSubject<[Diary]>(value: [])
    private var disposeBag = DisposeBag()
    private let diaryService: DiaryServicing
    
    init(diaryService: DiaryServicing) {
        self.diaryService = diaryService
    }
    
    func fetchDiaries(_ token: String) {
        diaryService.loadDiaries(with: token)
            .map { $0.results }
            .subscribe { [weak self] diaries in
                guard let self = self else { return }
                self.diaries.onNext(diaries)
            }
            .disposed(by: disposeBag)
    }
    
    func removeDiaries(objectId: String, token: String) {
        diaryService.deleteDiary(with: token, to: objectId)
            .subscribe { [weak self] _ in
                self?.fetchDiaries(token)
            }
            .disposed(by: disposeBag)
    }
}
