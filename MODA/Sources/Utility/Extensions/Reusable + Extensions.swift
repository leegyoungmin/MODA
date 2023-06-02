//
//  Reusable + Extensions.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol Reusable: AnyObject {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension UICollectionViewCell: Reusable { }
extension UITableViewCell: Reusable { }
