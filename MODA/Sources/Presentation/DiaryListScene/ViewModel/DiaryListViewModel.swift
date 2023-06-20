//
//  DiaryListViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class DiaryListViewModel: ViewModel {
    struct Input {
        var viewDidAppear: Observable<Void>
        var removeTargetItem: Observable<Diary>
        var updateTargetDiary: Observable<Diary>
        var selectedYear: Observable<Int>
        var selectedMonth: Observable<Int>
        var refresh: Observable<Void>
    }
    
    struct Output {
        var diaries: Observable<[Diary]>
        var removed: Observable<Void>
        var currentMonth: Observable<Int>
    }
    
    private let diaryListUseCase: DiaryListUseCase
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(diaryListUseCase: DiaryListUseCase) {
        self.diaryListUseCase = diaryListUseCase
    }
    
    func transform(input: Input) -> Output {
        let output = bindOutput(input: input)
        bindInput(input)
        return output
    }
    
    func bindOutput(input: Input) -> Output {
        let toggleDiary = input.updateTargetDiary
            .flatMapLatest { return self.diaryListUseCase.toggleLike(to: $0) }
        
        let deleteDiary = input.removeTargetItem
            .flatMapLatest { return self.diaryListUseCase.deleteItem(with: $0) }
        
        let selectedDay = Observable.merge([input.selectedYear, input.selectedMonth])
            .map { _ in }
        
        let diaries = Observable.merge([
            input.viewDidAppear,
            input.refresh,
            toggleDiary,
            deleteDiary,
            selectedDay
        ])
            .flatMapLatest { _ -> Observable<[Diary]> in
                return self.diaryListUseCase.loadAllDiaries(option: [:])
            }
        
        return Output(
            diaries: diaries,
            removed: diaryListUseCase.removeSuccess.asObservable(),
            currentMonth: diaryListUseCase.selectedMonth.asObservable()
        )
    }
    
    func bindInput(_ input: Input) {
        input.selectedMonth
            .bind(to: diaryListUseCase.selectedMonth)
            .disposed(by: disposeBag)
        
        input.selectedYear
            .bind(to: diaryListUseCase.selectedYear)
            .disposed(by: disposeBag)
    }
}
