//
//  AppDelegate.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Fabric
import Crashlytics

@UIApplicationMain
// swiftlint:disable force_cast

class AppDelegate: UIResponder, UIApplicationDelegate {

    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().backgroundColor = UIColor.white
        
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        FirebaseClient.shared.configure()
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

}
// swiftlint:ensable force_cast
