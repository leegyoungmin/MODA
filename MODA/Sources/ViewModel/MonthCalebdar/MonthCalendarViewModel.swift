//
//  MonthCalendarViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

final class MonthCalendarViewModel: ViewModel {
    struct Input {
        var didTapYearButton: Observable<Bool>
        var changeMonth: Observable<Int>
    }
    
    struct Output {
        var year: Observable<Int>
        var month: Observable<Int>
    }
    
    var selectedYear = BehaviorSubject<Int>(value: Date().toInt(.year))
    var selectedMonth = BehaviorSubject<Int>(value: Date().toInt(.month) - 1)
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init(month: Int? = nil) {
        if let month = month {
            selectedMonth.onNext(month)
        }
        
        print(Date().toInt(.year))
    }
    
    func transform(input: Input) -> Output {
        input.didTapYearButton
            .subscribe { [weak self] isUp in
                guard let self = self else { return }
                
                let plusValue = (isUp ? 1 : -1)
                try? selectedYear.onNext(selectedYear.value() + plusValue)
            }
            .disposed(by: disposeBag)
        
        input.changeMonth
            .subscribe { [weak self] selectedValue in
                guard let self = self else { return }
                
                self.selectedMonth.onNext(selectedValue)
            }
            .disposed(by: disposeBag)
        
        let output = Output(
            year: self.selectedYear.asObservable(),
            month: self.selectedMonth.asObservable()
        )
        return output
    }
}
