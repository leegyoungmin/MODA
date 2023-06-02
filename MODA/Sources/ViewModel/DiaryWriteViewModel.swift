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
    }
    
    struct Output {
        var disableConfirmButton: Observable<Bool>
    }
    
    private var selectedCondition = PublishSubject<Diary.Condition>()
    private var description = PublishSubject<String>()
    
    private var conditionValid = BehaviorSubject(value: false)
    private var descriptionValid = BehaviorSubject(value: false)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.selectedCondition
            .compactMap { Diary.Condition(rawValue: $0) }
            .debug()
            .bind(to: selectedCondition)
            .disposed(by: disposeBag)
        
        input.selectedCondition
            .map { _ in true }
            .bind(to: conditionValid)
            .disposed(by: disposeBag)
        
        input.descriptionInput
            .debug()
            .bind(to: description)
            .disposed(by: disposeBag)
        
        input.descriptionInput
            .map { $0.isEmpty == false }
            .bind(to: descriptionValid)
            .disposed(by: disposeBag)
        
        let disableButton = Observable.combineLatest(conditionValid, descriptionValid)
            .map { $0 && $1 }
        
        return Output(disableConfirmButton: disableButton)
    }
}
