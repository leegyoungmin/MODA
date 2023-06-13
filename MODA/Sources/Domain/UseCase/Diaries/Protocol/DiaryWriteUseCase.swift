//
//  DiaryWriteUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryWriteUseCase: AnyObject {
    var content: BehaviorSubject<String> { get set }
    var condition: BehaviorSubject<Int> { get set }
    var saveState: BehaviorSubject<DiaryWriteViewModel.SaveState> { get set }
    var isLike: BehaviorSubject<Bool> { get set }
    
    func loadTodayDiary()
    func postDiary() -> Observable<Void>
}
