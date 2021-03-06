//
//  LoadingViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var logoView: UIImageView!
    let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 6))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCornerRadius()
        progressView.backgroundColor = UIColor.P1
        backgroundView.addSubview(progressView)
        let fullWidth: CGFloat = backgroundView.bounds.width
        let newWidth = 100 / 100 * fullWidth
        
        UIView.animate(withDuration: 1.0) {
            self.progressView.frame.size = CGSize(width: newWidth, height: self.progressView.frame.height)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.checkStatus()
            })
        }

    }
    
    func getCornerRadius() {
        progressView.layer.cornerRadius = 3
    }
    
    func checkStatus() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        FIRAuthManager.shared.addSignUpListener { (signUpStatus) in
            if signUpStatus == false {
                let authVc = UIStoryboard.auth.instantiateInitialViewController()!
                
                delegate.window?.rootViewController = authVc
                
            } else {
                FIRFirestoreSerivce.shared.findUser { [weak self] _, findUser, userInfo  in
                    if findUser == true && userInfo?.mainGroupId != nil {
                        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
                        
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
