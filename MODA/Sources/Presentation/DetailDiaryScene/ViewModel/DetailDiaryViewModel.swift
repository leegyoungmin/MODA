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
        var editedContent: Observable<String>
        var didTapLikeButton: Observable<Void>
        var didTapDeleteButton: Observable<Void>
        var viewWillDisappear: Observable<Void>
    }
    
    struct Output {
        var diary: Observable<Diary>
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
        input.editedContent
            .bind(to: useCase.diaryContent)
            .disposed(by: disposeBag)
    }
    
    func bindingOutput(_ input: Input) -> Output {
        let updateDiary = Observable.merge([
            input.didTapSaveButton,
            input.viewWillDisappear
        ]).flatMapLatest { _ in return self.useCase.updateCurrentDiary() }
        
        let toggleDiaryLike = input.didTapLikeButton
            .flatMapLatest { _ in return self.useCase.toggleLike() }
        
        let fetchedDiary = Observable.merge([
            input.viewWillAppear,
            updateDiary,
            toggleDiaryLike
        ]).flatMapLatest {
            return self.useCase.fetchCurrentDiary()
        }
        
        let isEditable = fetchedDiary.compactMap {
            return $0.createdDate.isEqual(rhs: Date())
        }
        
        let deleteSuccess = input.didTapDeleteButton
            .flatMapLatest { return self.useCase.deleteCurrentDiary() }
            .catch { _ in return .empty() }
        
        return Output(
            diary: fetchedDiary,
            isEditable: isEditable,
            didSuccessRemove: deleteSuccess
        )
    }
}
