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
    
    func loadAllDiaries(option: [String: String]) -> Observable<[Diary]>
    func toggleLike(to newDiary: Diary) -> Observable<[Diary]>
//    func updateDiary(diary: Diary) -> Observable<[Diary]>
    func deleteItem(with diary: Diary)
}
