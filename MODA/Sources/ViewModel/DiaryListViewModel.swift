//
//  DiaryListViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
    
    init()
}

final class DiaryListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        var diaries: Observable<[Diary]>
    }
    
    let input: Input
    let output: Output
    
    init() {
        self.input = Input()
        self.output = Output(diaries: .of(Diary.mockDatas))
    }
}
