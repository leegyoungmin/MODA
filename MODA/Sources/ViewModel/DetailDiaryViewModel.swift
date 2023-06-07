//
//  DetailDiaryViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

final class DetailDiaryViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var didTapSaveButton: Observable<Void>
        var isEditMode: Observable<Bool>
        var editedContent: Observable<String?>
        var didTapDeleteButton: Observable<Void>
    }
    
    struct Output {
        var createdDate: Observable<String>
        var content: Observable<String?>
        var condition: Observable<Diary.Condition?>
        var isEditable: Observable<Bool>
        var didSuccessRemove: Observable<Void>
    }
    private let useCase: DetailDiaryUseCase
    
    var disposeBag = DisposeBag()
    
    init(useCase: DetailDiaryUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                useCase.fetchCurrentDiary("r:c8f161b6407a0799d377bc0425e48e12")
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.didTapSaveButton,
            input.isEditMode
        )
        .debug()
        .subscribe { [weak self] values in
            guard let self = self else { return }
            
            if values.1 {
                self.useCase.updateCurrentDiary("r:c8f161b6407a0799d377bc0425e48e12")
            }
        }
        .disposed(by: disposeBag)
        
        input.editedContent
            .bind(to: useCase.diaryContent)
            .disposed(by: disposeBag)
        
        input.didTapDeleteButton
            .debug()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.useCase.deleteCurrentDiary("r:c8f161b6407a0799d377bc0425e48e12")
            }
            .disposed(by: disposeBag)
        
        let createdDate = useCase.diaryDate
            .compactMap { $0?.toString("yyyy년 MM월 dd일") }
            .asObservable()
        
        let isEditable = useCase.diaryDate
            .compactMap { $0?.isEqual(rhs: Date()) }
            .asObservable()
        
        let output = Output(
            createdDate: createdDate,
            content: useCase.diaryContent.asObservable(),
            condition: useCase.diaryCondition.asObservable(),
            isEditable: isEditable,
            didSuccessRemove: useCase.removeDiary.asObservable()
        )
        
        return output
    }
}
