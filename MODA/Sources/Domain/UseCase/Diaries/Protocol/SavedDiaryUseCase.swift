//
//  SavedDiaryUseCase.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import RxSwift

protocol SavedDiaryUseCase: AnyObject {
    var savedDiaries: PublishSubject<[Diary]> { get set }
    
    func loadLikeDiaries()
}
