//
//  AppDelegate.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().backgroundColor = UIColor.white
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

        FIRFirestoreSerivce.shared.configure()
        
        return true
    }

}
