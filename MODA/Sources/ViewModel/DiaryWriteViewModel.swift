//
//  DiaryWriteViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

final class DiaryWriteViewModel: ViewModel {
    struct Input {
        var selectedCondition: Observable<Int>
        var descriptionInput: Observable<String>
        var saveButtonTap: Observable<Void>
        var cancelButtonTap: Observable<Void>?
    }
    
    struct Output {
        var disableConfirmButton: Observable<Bool>
        var dismissView: Observable<Bool>
    }
    
    private let diaryWriteUseCase: DiaryWriteUseCase
    
    private var selectedCondition = PublishSubject<Diary.Condition>()
    private var description = PublishSubject<String>()
    private var dismissView = BehaviorSubject(value: false)
    
    private var conditionValid = BehaviorSubject(value: false)
    private var descriptionValid = BehaviorSubject(value: false)
    
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
            disableConfirmButton: disableButton,
            dismissView: dismissView
        )
    }
    
    func bindingInput(_ input: Input) {
        input.selectedCondition
            .bind(to: diaryWriteUseCase.condition)
            .disposed(by: disposeBag)
        
        input.descriptionInput
            .bind(to: diaryWriteUseCase.content)
            .disposed(by: disposeBag)
        
        input.saveButtonTap.asObservable()
            .flatMapLatest { [weak self] _ -> Observable<Result<Void, Error>> in
                guard let self = self else { throw NetworkError.unknownError }
                
                return self.diaryWriteUseCase.createNewDiary(
                    token: "r:71be8a7f09796ced27e1242288a142b6",
                    with: "Vz9lsMuuKd"
                )
            }
            .subscribe { [weak self] result in
                switch result {
                case .success:
                    self?.dismissView.onNext(true)
                case .failure:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        input.cancelButtonTap?
            .subscribe { [weak self] _ in
                self?.dismissView.onNext(true)
            }
            .disposed(by: disposeBag)
    }
}
