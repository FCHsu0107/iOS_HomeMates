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
//    case Icons_36px_Cart_Normal
//    case Icons_36px_Cart_Selected
//    case Icons_36px_Catalog_Normal
//    case Icons_36px_Catalog_Selected
//    case Image_Logo02
    
    
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
