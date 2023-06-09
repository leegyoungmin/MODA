//
//  DetailDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift
import Foundation

protocol DetailDiaryUseCase: AnyObject {
    var selectedId: String { get }
    var currentDiary: BehaviorSubject<Diary?> { get set }
    var diaryDate: BehaviorSubject<Date?> { get set }
    var diaryContent: BehaviorSubject<String> { get set }
    var diaryCondition: BehaviorSubject<Diary.Condition?> { get set }
    var diaryLike: BehaviorSubject<Bool> { get set }
    
    func fetchCurrentDiary() -> Observable<Diary>
    func updateCurrentDiary() -> Observable<Void>
    func deleteCurrentDiary() -> Observable<Void>
    func toggleLike() -> Observable<Void>
}
