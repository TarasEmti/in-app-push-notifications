//
//  AppDelegate.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 14/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var pushNotificationsController = PushNotificationsController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showNotification(notification:)),
            name: .showNotification,
            object: nil
        )

        return true
    }

    @objc
    func showNotification(notification: Notification) {
        guard let push = notification.object as? LocalNotification else { return }

        pushNotificationsController.show(push)
        pushNotificationsController.onNotificationTap = { [weak self] in
            if let segueString = push.userInfo["segue"],
               let segue = PushSegue(rawValue: segueString) {
                self?.handleSegue(segue)
            }
        }
    }

    private func handleSegue(_ pushSegue: PushSegue) {
        switch pushSegue {
        case .chat:
            NotificationCenter.default.post(name: .openChatNotification, object: nil)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

