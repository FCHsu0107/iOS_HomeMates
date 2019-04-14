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
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        checkStatus()
//    }
//    
//    func checkStatus() {
//        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        Auth.auth().addStateDidChangeListener { (_, user) in
//            guard user != nil else {
//                
//                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//                if let authVc =
//                    storyboard.instantiateViewController(
//                        withIdentifier: String(describing: AuthViewController.self))
//                        as? AuthViewController {
//                    
//                    delegate.window?.rootViewController = authVc
//                }
//                return
//            }
//            guard let user = Auth.auth().currentUser else { return }
//            
//            let uid = user.uid
//            
//            let checkUser = FIRFirestoreSerivce.shared.findUser(uid: uid)
//            if checkUser == true {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                if let tabBarVc =
//                    storyboard.instantiateViewController(
//                        withIdentifier: String(describing: HMTabBarViewController.self))
//                        as? HMTabBarViewController {
//                    
//                    self.present(tabBarVc, animated: true, completion: nil)
//                    
//                    delegate.window?.rootViewController = tabBarVc
//                }
//            } else {
//                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
//                if let selectGroupVc =
//                    storyboard.instantiateViewController(
//                        withIdentifier: String(describing: GroupSelectionViewController.self))
//                        as? GroupSelectionViewController {
//                    
//                    self.present(selectGroupVc, animated: true, completion: nil)
//                }
//            }
//        }
//    }
}
