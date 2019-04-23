//
//  StatusBackgroundColor.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/23.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class StatusBackgroundColor {
    private init() {}
    
    static func statusBarForAlertView() {
        guard let statusBar = UIApplication.shared.value(
            forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = UIColor(red: 145, green: 125, blue: 51, alpha: 0)
    }
}
