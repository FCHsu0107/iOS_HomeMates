//
//  AppDelegate.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().backgroundColor = UIColor.white
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        FirebaseApp.configure()
        
//        let semophore = DispatchSemaphore(value: 0)
        
        Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            
//            semophore.signal()
            
            guard user != nil else {
            
                //Login
                
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                
                self?.window?.rootViewController = storyboard.instantiateInitialViewController()
                
                return
            }
            
            //Lobby
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            self?.window?.rootViewController = storyboard.instantiateInitialViewController()
            
        }
        
//        semophore.wait()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
     
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

}
