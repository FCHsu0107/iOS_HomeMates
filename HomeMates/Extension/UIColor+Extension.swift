//
//  UIColor+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
// swiftlint:disable identifier_name
private enum HMColor: String {

    case B1

    case B2

    case P1

    case Y1

    case Y2

    case Y3

    case Y4
}

@available(iOS 11.0, *)
extension UIColor {

    static let B1 = HMColor(.B1)

    static let B2 = HMColor(.B2)

    static let P1 = HMColor(.P1)

    static let Y1 = HMColor(.Y1)

    static let Y2 = HMColor(.Y2)

    static let Y3 = HMColor(.Y3)

    static let Y4 = HMColor(.Y4)

    private static func HMColor(_ color: HMColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
// swiftlint:enable identifier_name
