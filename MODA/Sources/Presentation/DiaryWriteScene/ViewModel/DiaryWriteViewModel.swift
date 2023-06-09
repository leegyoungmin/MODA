//
//  DiaryWriteViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DiaryWriteViewModel: ViewModel {
    struct Input {
        var viewWillAppear: Observable<Void>
        var selectedCondition: Observable<Int>
        var descriptionInput: Observable<String>
        var saveButtonTap: Observable<Void>
        var cancelButtonTap: Observable<Void>
    }
    
    struct Output {
        var description: Observable<String>
        var selectedCondition: Observable<Int>
        var disableConfirmButton: Observable<Bool>
        var saveState: Observable<SaveState>
        var dismissView: Observable<Bool>
    }
    
    private let diaryWriteUseCase: DiaryWriteUseCase
    
    private var dismissView = BehaviorSubject(value: false)
    
    var disposeBag = DisposeBag()
    
    init(diaryWriteUseCase: DiaryWriteUseCase) {
        self.diaryWriteUseCase = diaryWriteUseCase
    }
    
    func transform(input: Input) -> Output {
        
        bindingInput(input)
        
        let disableButton = Observable.combineLatest(
            diaryWriteUseCase.content.asObservable(),
            diaryWriteUseCase.condition.asObservable(),
            resultSelector: { $0.isEmpty == false && Diary.Condition(rawValue: $1) != nil }
        )
        
        return Output(
            description: diaryWriteUseCase.content.asObservable(),
            selectedCondition: diaryWriteUseCase.condition.asObservable(),
            disableConfirmButton: disableButton,
            saveState: diaryWriteUseCase.saveState.asObservable(),
            dismissView: dismissView
        )
    }
    
    func bindingInput(_ input: Input) {
        input.viewWillAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.diaryWriteUseCase.loadTodayDiary()
            }
            .disposed(by: disposeBag)
        
        input.selectedCondition
            .bind(to: diaryWriteUseCase.condition)
            .disposed(by: disposeBag)
        
        input.descriptionInput
            .bind(to: diaryWriteUseCase.content)
            .disposed(by: disposeBag)
        
        let saveSuccess = input.saveButtonTap.asObservable()
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { throw NetworkError.unknownError }
                
                return self.diaryWriteUseCase.postDiary()
            }
        
        Observable.of(saveSuccess, input.cancelButtonTap)
            .merge()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.dismissView.onNext(true)
            }
            .disposed(by: disposeBag)
    }
}

extension DiaryWriteViewModel {
    enum SaveState {
        case none
        case loading
        case success
        case failure
    }
}
