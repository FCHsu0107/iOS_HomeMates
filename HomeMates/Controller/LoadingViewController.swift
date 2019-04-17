//
//  LoadingViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkStatus()
    }
    
    func checkStatus() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        FIRAuthService.shared.addSignUpListener { (flag) in
            if flag == false {
               let authVc = UIStoryboard.auth.instantiateInitialViewController()!
                    
                    delegate.window?.rootViewController = authVc
                return
                
            } else {
                FIRFirestoreSerivce.shared.findUser { [weak self] bool in
                    if bool == true {
                        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
                            
                            self?.present(tabBarVc, animated: true, completion: nil)
                            
                            delegate.window?.rootViewController = tabBarVc

                    } else {
                        if let selectGroupVc =
                            UIStoryboard.auth.instantiateViewController(
                                withIdentifier: String(describing: GroupSelectionViewController.self))
                                as? GroupSelectionViewController {
                            
                            self?.present(selectGroupVc, animated: true, completion: nil)
                            
                        }
                    }
                }
            }
        }
    }
}
