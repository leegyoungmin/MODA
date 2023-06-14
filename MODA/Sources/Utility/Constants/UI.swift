//
//  UI.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

enum UIConstants {
    enum Colors {
        static let backgroundColor = UIColor(named: "BackgroundColor")
        static let secondaryColor = UIColor(named: "SecondaryColor")
        static let accentColor = UIColor(named: "AccentColor")
    }
    
    enum Images {
        static let appIcon = UIImage(named: "MODAIcon")
        static let star = UIImage(systemName: "star")
        static let starFill = UIImage(systemName: "star.fill")
        static let trash = UIImage(systemName: "trash")
        static let pencil = UIImage(systemName: "pencil")
        static let arrowUp = UIImage(systemName: "arrow.up")
        static let arrowLeft = UIImage(systemName: "chevron.left")
        static let arrowRight = UIImage(systemName: "chevron.right")
        static let arrowDown = UIImage(systemName: "chevron.down.circle.fill")
        static let homeIcon = UIImage(systemName: "list.bullet")
        static let saveIcon = Self.star
        static let settingIcon = UIImage(systemName: "gearshape")
        static let xmarkIcon = UIImage(systemName: "xmark.circle.fill")
    }
}
