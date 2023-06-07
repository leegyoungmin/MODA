//
//  DetailDiaryViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

final class DetailDiaryViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        var createdDate: Observable<String?>
        var content: Observable<String?>
        var condition: Observable<Diary.Condition?>
        var isEditable: Observable<Bool>
    }
    private var currentDiary: Diary?
    
    var disposeBag = DisposeBag()
    
    init(currentDiary: Diary? = nil) {
        self.currentDiary = currentDiary
    }
    
    func transform(input: Input) -> Output {
        return Output(
            createdDate: Observable.of(currentDiary?.createdDate.toString("yyyy년 MM월 dd일")),
            content: Observable.of(currentDiary?.content),
            condition: Observable.of(currentDiary?.condition),
            isEditable: Observable.of(currentDiary?.createdDate.isEqual(rhs: Date()) ?? false)
        )
    }
}
