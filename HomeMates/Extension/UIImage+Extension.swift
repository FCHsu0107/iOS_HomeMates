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

    case Bulletin_36px
    case Back_24px
    case Setting_36px
    case Toggle_24px
    
    case Profile_80px
    case Home_48px
    
    case Edit02_24px
    case Editor_24px
    
    case Remove_24px
    
    //Task pictrue and tracker picture
    case profile_48px
    case Housework_48px
    
    //App logo
    case HomeMates
    
    //Tab bar icon
    case Profile_selected_24px
    case Profile_24px
    case Statistic_selected_24px
    case Statistic_24px
    case Task_selected_24px
    case Task_24px
    case Home_selected_24px
    case Home_24px
}

extension UIImage {

    static func asset(_ asset: ImageAsset) -> UIImage? {

        return UIImage(named: asset.rawValue)
    }
}

// swiftlint:enable identifier_name
