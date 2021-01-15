//
//  Extensions.swift
//  InAppPushNotifications
//
//  Created by Тарас Минин on 15/01/2021.
//

import UIKit

extension String {
    func image(
        font: UIFont,
        size: CGSize = CGSize(width: 40, height: 40)
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
