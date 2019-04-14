//
//  LoadingViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        Auth.auth().addStateDidChangeListener { (_, user) in
            guard user != nil else {
                
                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                if let authVc =
                    storyboard.instantiateViewController(
                        withIdentifier: String(describing: AuthViewController.self))
                        as? AuthViewController {
                    
                    delegate.window?.rootViewController = authVc
                }
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVc =
                storyboard.instantiateViewController(
                    withIdentifier: String(describing: HMTabBarViewController.self))
                    as? HMTabBarViewController {
                
                self.present(tabBarVc, animated: true, completion: nil)
                
                delegate.window?.rootViewController = tabBarVc
            }
        }
    }
}


//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//
//    Auth.auth().addStateDidChangeListener { (_, user) in
//
//        guard user != nil else {
//
//            let storyboard = UIStoryboard(name: "LogInAndSignUp", bundle: nil)
//            if let logInVC =
//                storyboard.instantiateViewController(
//                    withIdentifier: String(describing: LogInAndSignUpViewController.self))
//                    as? LogInAndSignUpViewController {
//
//                guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
//                    return
//                }
//
//                delegate.window?.rootViewController = logInVC
//            }
//            return
//        }
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//        if let tabBarVC =
//            storyboard.instantiateViewController(
//                withIdentifier: String(describing: TabBarViewController.self)) as? TabBarViewController {
//            self.present(tabBarVC, animated: true, completion: nil)
//
//            guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//
//            delegate.window?.rootViewController = tabBarVC
//        }
//    }
//}
