//
//  ViewController.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 14/01/2021.
//

import UIKit

class ViewController: UIViewController {

    private var pushButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show push", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.325, green: 0.557, blue: 0.957, alpha: 1.0)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.149, green: 0.149, blue: 0.247, alpha: 1.0)
        title = "InApp Notifications"

        pushButton.addTarget(
            self,
            action: #selector(sendPushNotification),
            for: .touchUpInside
        )
        view.addSubview(pushButton)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(openChat),
            name: .openChatNotification,
            object: nil
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pushButton.frame = CGRect(origin: .zero, size: pushButton.intrinsicContentSize)
        pushButton.center = view.center
    }

    @objc
    func sendPushNotification() {
        let push = LocalNotification(
            title: "Show Push Tapped",
            body: "Congrats! 💫",
            userInfo: ["segue": PushSegue.chat.rawValue]
        )

        NotificationCenter.default.post(name: .showNotification, object: push)
    }

    @objc
    func openChat() {
        navigationController?.pushViewController(ChatViewController(), animated: true)
    }
}

enum PushSegue: String {
    case chat
}
