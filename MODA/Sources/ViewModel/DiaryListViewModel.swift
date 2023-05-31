//
//  DiaryListViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DiaryListViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var removeTargetItem: Observable<Diary>
    }
    
    struct Output {
        var diaries = BehaviorSubject<[Diary]>(value: [])
        var removed: Observable<Void> = .of(())
    }
    
    private let diaryRepository: DiaryListRepository
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(diaryRepository: DiaryListRepository) {
        self.diaryRepository = diaryRepository
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        bindOutput(output)
        bindInput(input)
        return output
    }
    
    func bindOutput(_ output: Output) {
        diaryRepository.diaries
            .subscribe { diaries in
                output.diaries.on(diaries)
            }
            .disposed(by: disposeBag)
    }
    
    func bindInput(_ input: Input) {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.diaryRepository.fetchDiaries("r:b8007cc20843c502703f13bc08d7e3da")
            }
            .disposed(by: disposeBag)
        
        input.removeTargetItem
            .subscribe { [weak self] diary in
                guard let self = self else { return }
                self.diaryRepository.removeDiaries(
                    objectId: diary.id,
                    token: "r:b8007cc20843c502703f13bc08d7e3da"
                )
            }
            .disposed(by: disposeBag)
    }
}
