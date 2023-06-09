//
//  AppDelegate.swift
//  MODA
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let repository = DefaultUserRepository(service: UserService())
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        registerRemoteNotifications()
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02x", $0) }.joined()
        
        guard let identifier = Bundle.main.bundleIdentifier else { return }
        
        let body: [String: Any] = generateInstallationBody(token: token, bundleIdentifier: identifier)
        
        repository.saveInstallation(body)
    }
}

private extension AppDelegate {
    func generateInstallationBody(token: String, bundleIdentifier: String) -> [String: Any] {
        return [
            "deviceToken": token,
            "localeIdentifier": Constants.localIdentifier,
            "parseVersion": Constants.parseVersion,
            "appIdentifier": bundleIdentifier,
            "appName": Constants.appName,
            "deviceType": Constants.deviceType,
            "channels": Constants.channels,
            "installationId": Constants.installationId,
            "appVersion": Constants.appVersion,
            "timeZone": Constants.timeZone
        ]
    }
    
    func registerRemoteNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { granted, _ in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}

private extension AppDelegate {
    enum Constants {
        static let localIdentifier = Locale.current.identifier
        static let parseVersion = "2.2.0"
        static let appName = "MODA"
        static let deviceType = "ios"
        static let channels: [String] = ["diary"]
        static let installationId = UUID().uuidString
        static let appVersion = UIApplication.version().description
        static let timeZone = TimeZone.current.identifier
    }
}
