//
//  PushNotificationView.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 14/01/2021.
//

import UIKit

final class NativeLocalNotificationView: UIView {

    lazy var button = UIButton()

    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true

        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero

        return view
    }()

    private lazy var blurBackground = UIVisualEffectView(
        effect: UIBlurEffect(style: .light)
    )

    private lazy var appIconView: UIImageView = {

        let pushImage = "☕️".image(
            font: .systemFont(ofSize: 15),
            size: CGSize(width: 20, height: 20)
        )
        let view = UIImageView(image: pushImage)
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 5
        view.clipsToBounds = true

        return view
    }()

    private lazy var appLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11, weight: .regular)
        view.text = "Push App Test"
        view.textColor = UIColor.black.withAlphaComponent(0.5)
        view.numberOfLines = 1

        return view
    }()

    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11, weight: .regular)
        view.text = "now"
        view.textAlignment = .right
        view.textColor = UIColor.black.withAlphaComponent(0.5)
        view.numberOfLines = 1

        return view
    }()

    private lazy var authorLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14, weight: .semibold)
        view.textColor = .black

        return view
    }()

    private lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = UIColor.black.withAlphaComponent(0.8)

        return view
    }()

    init(_ notification: LocalNotification) {
        super.init(frame: .zero)
        setup(notification)

        addSubview(background)
        background.addSubview(blurBackground)
        background.addSubview(button)
        background.addSubview(appIconView)
        background.addSubview(appLabel)
        background.addSubview(dateLabel)
        background.addSubview(authorLabel)
        background.addSubview(messageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func setup(_ notification: LocalNotification) {
        authorLabel.text = notification.title
        messageLabel.text = notification.body
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        bounds = CGRect(
            origin: .zero,
            size: CGSize(width: size.width, height: 0)
        )
        layoutSubviews()

        return CGSize(width: size.width, height: background.frame.maxY)
    }

    override func layoutSubviews() {

        let offset: CGFloat = 12
        let smallOffset: CGFloat = 8

        background.frame = CGRect(
            x: smallOffset,
            y: 0,
            width: bounds.width - smallOffset * 2,
            height: 0
        )

        appIconView.frame = CGRect(
            x: offset,
            y: offset,
            width: 20,
            height: 20
        )

        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(
            x: background.frame.width - dateLabel.bounds.width - offset,
            y: offset + (20 - dateLabel.font.lineHeight) / 2,
            width: dateLabel.bounds.width,
            height: dateLabel.font.lineHeight
        )

        appLabel.sizeToFit()
        appLabel.frame = CGRect(
            x: appIconView.frame.maxX + smallOffset,
            y: dateLabel.frame.origin.y,
            width: appLabel.bounds.width,
            height: appLabel.font.lineHeight)

        authorLabel.frame = CGRect(
            x: offset,
            y: appIconView.frame.maxY + smallOffset,
            width: background.frame.width - offset * 2,
            height: authorLabel.font.lineHeight
        )

        messageLabel.frame = CGRect(
            x: offset,
            y: authorLabel.frame.maxY + smallOffset,
            width: background.frame.width - offset * 2,
            height: messageLabel.font.lineHeight
        )

        background.frame = CGRect(
            x: smallOffset,
            y: 0,
            width: bounds.width - smallOffset * 2,
            height: messageLabel.frame.maxY + offset
        )

        blurBackground.frame = background.bounds
        button.frame = background.bounds
    }
}
