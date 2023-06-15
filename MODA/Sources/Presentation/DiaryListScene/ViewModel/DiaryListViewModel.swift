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
        var isLikeItem: Observable<Diary>
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
        return Output(
            diaries: diaryListUseCase.diaries.asObservable(),
            removed: diaryListUseCase.removeSuccess.asObservable(),
            currentMonth: diaryListUseCase.selectedMonth.asObservable()
        )
    }
    
    func bindInput(_ input: Input) {
        Observable.of(input.viewDidAppear, input.refresh)
            .merge()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.diaryListUseCase.loadAllDiaries(option: [:])
            }
            .disposed(by: disposeBag)
        
        input.selectedMonth
            .bind(to: diaryListUseCase.selectedMonth)
            .disposed(by: disposeBag)
        
        input.selectedYear
            .bind(to: diaryListUseCase.selectedYear)
            .disposed(by: disposeBag)
        
        input.isLikeItem
            .subscribe { [weak self] diary in
                guard var newDiary = diary.element else { return }
                newDiary.isLike.toggle()
                
                self?.diaryListUseCase.updateDiary(diary: newDiary)
            }
            .disposed(by: disposeBag)
        
        input.removeTargetItem
            .subscribe { [weak self] diary in
                guard let self = self else { return }
                self.diaryListUseCase.deleteItem(with: diary)
            }
            .disposed(by: disposeBag)
        
        Observable.of(diaryListUseCase.selectedYear, diaryListUseCase.selectedMonth)
            .merge()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.diaryListUseCase.loadAllDiaries(option: [:])
            }
            .disposed(by: disposeBag)
    }
}
