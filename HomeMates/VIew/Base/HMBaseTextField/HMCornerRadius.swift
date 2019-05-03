//
//  HMCornerRadius.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

class HMCornerRadius {
    
    static let shared = HMCornerRadius()
    
    func setLayer(view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    func setLayer(lable: UILabel, cornerRadius: CGFloat) {
        lable.layer.cornerRadius = cornerRadius
        lable.layer.shadowOpacity = 0.2
        lable.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
}
