//
//  TabViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class TabViewController: UITabBarController {
    private let routers = Router.allCases
    private let currentUser: User?
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.currentUser = nil
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers = routers.map {
            let tabItem = configureTabBarItem(with: $0)
            let controller = $0.instance
            controller.tabBarItem = tabItem
            return UINavigationController(rootViewController: controller)
        }
        
        setViewControllers(controllers, animated: true)
    }
    
    private func configureTabBarItem(with router: Router) -> UITabBarItem {
        return UITabBarItem(
            title: router.title,
            image: UIImage(systemName: router.imageName),
            tag: router.rawValue
        )
    }
}

private extension TabViewController {
    enum Router: Int, CaseIterable {
        case home
        case save
        case setting
        
        var title: String {
            switch self {
            case .home:     return "홈"
            case .save:     return "저장일기"
            case .setting:  return "설정"
            }
        }
        
        var imageName: String {
            switch self {
            case .home:     return "list.bullet"
            case .save:     return "star"
            case .setting:  return "gearshape"
            }
        }
        
        var instance: UIViewController {
            switch self {
            case .home:     return DiaryListViewController()
            case .save:     return SavedDiaryViewController()
            case .setting:  return SettingViewController()
            }
        }
    }
}
