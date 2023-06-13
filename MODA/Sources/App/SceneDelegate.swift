//
//  SceneDelegate.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewModel = SignInViewModel(
            useCase: DefaultSignInUseCase(
                repository: DefaultAuthRepository(
                    service: UserService()
                )
            )
        )
        let controller = SignInViewController(viewModel: viewModel)
        window?.rootViewController = controller
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}
