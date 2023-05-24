//
//  TabViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class TabViewController: UITabBarController {
    
    private let listViewController = DiaryListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        listViewController.tabBarItem = tabBarItem
        
        let controllers = [listViewController]
            .map { UINavigationController(rootViewController: $0) }
        setViewControllers(controllers, animated: true)
    }
}
