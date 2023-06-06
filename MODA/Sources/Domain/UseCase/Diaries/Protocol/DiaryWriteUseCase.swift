//
//  DiaryWriteUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol DiaryWriteUseCase: AnyObject {
    var content: BehaviorSubject<String> { get set }
    var condition: BehaviorSubject<Int> { get set }
    var saveState: BehaviorSubject<Bool> { get set }
    
    func loadTodayDiary(_ token: String)
    func postDiary(token: String, with userId: String) -> Observable<Void>
}
