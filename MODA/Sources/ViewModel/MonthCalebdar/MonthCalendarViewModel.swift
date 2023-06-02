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
    
    var selectedYear = 0
    var selectedMonth = 0
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        let current = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: current)
        
        if let year = components.year {
            self.selectedYear = year
        }
        
        if let month = components.month {
            self.selectedMonth = month
        }
    }

    func transform(input: Input) -> Output {
        let currentYear = input.didTapYearButton
            .debug()
            .compactMap { [weak self] increase in
                guard let self = self else { return 0 }
                
                let increaseValue = (increase ? 1 : -1)
                self.selectedYear += increaseValue
                return self.selectedYear
            }
        
        let currentMonth = input.changeMonth
            .debug()
            .compactMap { [weak self] selectedValue in
                guard let self = self else { return 0 }
                
                self.selectedMonth = selectedValue
                return self.selectedMonth
            }
        
        let output = Output(
            year: currentYear.asObservable(),
            month: currentMonth.asObservable()
        )
        return output
    }
}
