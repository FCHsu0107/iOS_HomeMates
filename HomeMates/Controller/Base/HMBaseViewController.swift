//
//  HMBaseViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import IQKeyboardManager

class HMBaseViewController: UIViewController {

    var navigationBarIsHidden: Bool {
        
        return false
    }
    
    var isEnableIQKeyboard: Bool {
        
        return true
    }
    
    var isEnableResignOnTouchOutside: Bool {
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationBarIsHidden {
            navigationItem.hidesBackButton = true
        }
        navigationController?.navigationBar.barTintColor = UIColor.Y1
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage.asset(.Back_24px)
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.asset(.Back_24px)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationBarIsHidden {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = false
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if navigationBarIsHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        if !isEnableIQKeyboard {
            IQKeyboardManager.shared().isEnabled = true
        }
        
        if !isEnableResignOnTouchOutside {
            IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        }
    }
    
    @IBAction func popBack(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }

}
