//
//  NotificationCenter + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import RxSwift

extension Notification {
    static func keyboardWillShow() -> Observable<CGFloat> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map {
                ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .asObservable()
    }
    
    static func keyboardWillHide() -> Observable<CGFloat> {
        return NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ in 0 }
    }
}
