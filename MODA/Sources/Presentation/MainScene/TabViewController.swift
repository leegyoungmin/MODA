//
//  TabViewController.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class TabViewController: UITabBarController {
    private let routers = Router.allCases
    
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
            image: router.icon,
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
            case .home:     return "home"~
            case .save:     return "saved_diary"~
            case .setting:  return "setting"~
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .home:     return UIConstants.Images.homeIcon
            case .save:     return UIConstants.Images.saveIcon
            case .setting:  return UIConstants.Images.settingIcon
            }
        }
        
        var instance: UIViewController {
            switch self {
            case .home:
                let controller = DiaryListViewController()
                let viewModel = DiaryListViewModel(
                    diaryListUseCase: DefaultDiaryListUseCase(
                        diaryRepository: DefaultDiaryRepository(
                            diaryService: DiaryService()
                        )
                    )
                )
                controller.setViewModel(with: viewModel)
                return controller
            case .save:
                let controller = SavedDiaryViewController()
                let viewModel = SavedDiaryViewModel(
                    useCase: DefaultSavedDiaryUseCase(
                        repository: DefaultDiaryRepository(
                            diaryService: DiaryService()
                        )
                    )
                )
                controller.setViewModel(with: viewModel)
                return controller
            case .setting:  return SettingViewController()
            }
        }
    }
}
