//
//  UIImage+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

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
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
