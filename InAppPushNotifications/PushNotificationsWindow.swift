//
//  PushNotificationsWindow.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 14/01/2021.
//

import UIKit

final class PushNotificationsWindow: UIWindow {

    weak var notificationView: UIView?

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let notif = notificationView else { return false }
        let touchPoint = convert(point, to: notif)

        return notif.point(inside: touchPoint, with: event)
    }
}
