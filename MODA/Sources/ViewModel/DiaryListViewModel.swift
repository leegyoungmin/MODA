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
        var selectedYear: Observable<Int>
        var selectedMonth: Observable<Int>
    }
    
    struct Output {
        var diaries = BehaviorSubject<[Diary]>(value: [])
        var removed: Observable<Void> = .of(())
        var currentMonth = PublishSubject<Int>()
    }
    
    private let diaryListUseCase: DiaryListUseCase
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(diaryListUseCase: DiaryListUseCase) {
        self.diaryListUseCase = diaryListUseCase
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        bindOutput(output)
        bindInput(input)
        return output
    }
    
    func bindOutput(_ output: Output) {
        diaryListUseCase.diaries
            .subscribe { diaries in
                output.diaries.on(diaries)
            }
            .disposed(by: disposeBag)
        
        diaryListUseCase.selectedMonth
            .subscribe { month in
                output.currentMonth.onNext(month)
            }
            .disposed(by: disposeBag)
    }
    
    func bindInput(_ input: Input) {
        input.viewDidAppear
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.diaryListUseCase.loadAllDiaries("r:73c87143778dd7a511da231909e85932")
            }
            .disposed(by: disposeBag)
        
        input.selectedMonth
            .bind(to: diaryListUseCase.selectedMonth)
            .disposed(by: disposeBag)
        
        input.selectedYear
            .bind(to: diaryListUseCase.selectedYear)
            .disposed(by: disposeBag)
        
        Observable.of(diaryListUseCase.selectedYear, diaryListUseCase.selectedMonth)
            .merge()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                
                self.diaryListUseCase.loadAllDiaries("r:73c87143778dd7a511da231909e85932")
            }
            .disposed(by: disposeBag)
    }
}
