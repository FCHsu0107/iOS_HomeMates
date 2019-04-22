//
//  UIImage+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
// swiftlint:disable identifier_name
enum ImageAsset: String {

    // Profile tab - Tab
    case home_normal
    case home
    case profile_normal
    case profile
    case Task_36px_noraml
    case Task_36px
    case Statistic_24px_normal
    case Statistic_24px
    case Tips_24px_normal
    case Tips_24px
    case Idea_24px_normal
    case Idea_24px

    case Bullhorn_36px
    case Back_24px
    case Setting_36px
    case Toggle_24px
    
    case Addition_36px
    
    case Profile_80px
    case Home_48px
    case Edit_36px
    case Edit_24px
    
    case Edit02_24px
    
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}

// swiftlint:enable identifier_name
