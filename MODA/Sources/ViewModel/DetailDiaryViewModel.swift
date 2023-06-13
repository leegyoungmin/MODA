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
        var viewWillDisappear: Observable<Void>
    }
    
    struct Output {
        var createdDate: Observable<String>
        var content: Observable<String?>
        var condition: Observable<Diary.Condition?>
        var isLike: Observable<Bool>
        var isEditable: Observable<Bool>
        var didSuccessRemove: Observable<Void>
    }
    private let useCase: DetailDiaryUseCase
    
    var disposeBag = DisposeBag()
    
    init(useCase: DetailDiaryUseCase) {
        self.useCase = useCase
    }
    
    func transform(input: Input) -> Output {
        bindingInput(input)
        let output = bindingOutput(input)
        return output
    }
    
    func bindingInput(_ input: Input) {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                useCase.fetchCurrentDiary()
            }
            .disposed(by: disposeBag)
        
        let didTapSaveButton = Observable.combineLatest(
            input.didTapSaveButton,
            input.isEditMode
        ).map { return $0.1 }
        
        Observable.of(didTapSaveButton.asObservable(), input.viewWillDisappear.map { true }).merge()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.useCase.updateCurrentDiary()
            }
            .disposed(by: disposeBag)
        
        input.editedContent
            .bind(to: useCase.diaryContent)
            .disposed(by: disposeBag)
        
        input.didTapDeleteButton
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.useCase.deleteCurrentDiary()
            }
            .disposed(by: disposeBag)
    }
    
    func bindingOutput(_ input: Input) -> Output {
        let createdDate = useCase.diaryDate
            .compactMap { $0?.toString("yyyy년 MM월 dd일") }
            .asObservable()
        
        let isEditable = useCase.diaryDate
            .compactMap { $0?.isEqual(rhs: Date()) }
            .asObservable()
        
        return Output(
            createdDate: createdDate,
            content: useCase.diaryContent.asObservable(),
            condition: useCase.diaryCondition.asObservable(),
            isLike: useCase.diaryLike.asObservable(),
            isEditable: isEditable,
            didSuccessRemove: useCase.removeDiary.asObservable()
        )
    }
}
