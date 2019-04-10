//
//  AuthViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class AuthViewController: HMBaseViewController {

    @IBOutlet weak var authTopView: UIImageView!
    
    @IBOutlet weak var authBottomView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var checkTextField: UITextField!
    
    @IBOutlet weak var authInfoView: UIView!
//        {
//        didSet {
//            authTopView.layer.cornerRadius = 10
//            authTopView.layer.shadowOpacity = 0.2
//        }
//    }
    
    @IBOutlet weak var enterButton: UIButton!
//        {
//        didSet {
//            enterButton.layer.cornerRadius = 18
//            enterButton.layer.shadowOpacity = 0.2
//        }
//    }
    
    @IBOutlet weak var selectModeView: UIView!
//        {
//        didSet {
//            selectModeView.layer.cornerRadius = 18
//            selectModeView.layer.shadowOpacity = 0.2
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func enterBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVC =
            storyboard.instantiateViewController(
                withIdentifier: String(describing: HMTabBarViewController.self)) as? HMTabBarViewController {
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
}
