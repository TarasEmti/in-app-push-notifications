//
//  PushNotificationsController.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 14/01/2021.
//

import UIKit

extension Notification.Name {
    static let showNotification = Notification.Name("showNotification")
    static let openChatNotification = Notification.Name("openChatNotification")
}

final class PushNotificationsController: UIViewController {

    private static let notificationLifetime: TimeInterval = 6
    private static let notificationAnimationTime: TimeInterval = 0.3

    private let window: PushNotificationsWindow
    private var currentNotificationView: NativeLocalNotificationView?
    private var maxOriginY: CGFloat {
        if hasNotch {
            return view.safeAreaInsets.top
        } else {
            return 8
        }
    }

    var onNotificationTap: (() -> Void)?

    init() {
        window = PushNotificationsWindow(
            windowScene: UIApplication.shared.windows.first!.windowScene!
        )

        super.init(nibName: nil, bundle: nil)

        window.windowLevel = .alert
        window.rootViewController = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ notification: LocalNotification) {
        let notificationView = NativeLocalNotificationView(notification)
        window.isHidden = false
        window.notificationView = notificationView.button

        hideCurrentNotification()
        currentNotificationView = notificationView
        view.addSubview(notificationView)

        addGestures(notificationView)
        layout(notificationView)

        UIView.animate(
            withDuration: Self.notificationAnimationTime,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                notificationView.frame.origin.y = self.maxOriginY
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.perform(
                    #selector(self.hideCurrentNotification),
                    with: nil,
                    afterDelay: Self.notificationLifetime
                )
            }
        )
    }

    private func addGestures(_ view: NativeLocalNotificationView) {
        let panGr = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan(_:))
        )
        view.button.addGestureRecognizer(panGr)
        view.button.addTarget(
            self,
            action: #selector(didTapNotification),
            for: .touchUpInside
        )
    }

    @objc
    func handlePan(_ pangr: UIPanGestureRecognizer) {
        let maxOriginY = self.maxOriginY
        let view = currentNotificationView!

        let offset = pangr.translation(in: view.button)
        pangr.setTranslation(.zero, in: view.button)

        var origin = view.frame.origin
        origin.y += offset.y

        view.frame.origin.y = min(origin.y, maxOriginY)

        if pangr.state == .ended || pangr.state == .cancelled {
            let treshold: CGFloat = maxOriginY / 2
            if maxOriginY - view.frame.origin.y > treshold {
                hideCurrentNotification()
            } else {
                UIView.animate(
                    withDuration: Self.notificationAnimationTime / 3,
                    animations: {
                        view.frame.origin.y = maxOriginY
                    }
                )
            }
        }
    }

    private func layout(_ view: UIView) {
        view.frame = CGRect(
            origin: .zero,
            size: view.sizeThatFits(self.view.bounds.size)
        )
        view.frame.origin.y = -view.frame.height
    }

    @objc
    func hideCurrentNotification() {
        Self.cancelPreviousPerformRequests(withTarget: self)
        guard let view = currentNotificationView else { return }
        view.button.isUserInteractionEnabled = false
        currentNotificationView = nil

        UIView.animate(
            withDuration: Self.notificationAnimationTime,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                view.frame.origin.y = -view.frame.height
            },
            completion: { [weak self] _ in
                view.removeFromSuperview()
                if self?.currentNotificationView != nil { return }
                self?.window.isHidden = true
            }
        )
    }

    @objc
    private func didTapNotification() {
        hideCurrentNotification()
        onNotificationTap?()
    }

    override var prefersStatusBarHidden: Bool {
        return !hasNotch
    }

    var hasNotch: Bool {
        let bottom = view.safeAreaInsets.bottom
        return bottom > 0
    }
}
