//
//  DiaryListViewModel.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import RxSwift

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}

final class DiaryListViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
        var diaries: Observable<[Diary]>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let diaries = self.loadDiary()
        
        return Output(diaries: diaries)
    }
    
    func loadDiary() -> Observable<[Diary]> {
        return DiaryService()
            .loadDiaries(with: "r:e4fb8cd8e9dbd6136ca80b767aec45db")
    }
}
