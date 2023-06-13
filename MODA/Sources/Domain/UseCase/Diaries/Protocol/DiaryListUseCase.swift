//
//  DiaryListUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryListUseCase {
    var diaries: PublishSubject<[Diary]> { get }
    var selectedYear: BehaviorSubject<Int> { get set }
    var selectedMonth: BehaviorSubject<Int> { get set }
    var removeSuccess: PublishSubject<Void> { get set }
    
    func loadAllDiaries()
    func deleteItem(with diary: Diary)
}
