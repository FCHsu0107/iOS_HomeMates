//
//  ProfileSettingsViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/20.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: HMBaseViewController {

    @IBOutlet weak var userPictrueImage: UIImageView!
    
    @IBOutlet weak var userNameTextField: HMBaseTextField!
    
    @IBOutlet weak var ownGroupTextField: HMBaseTextField!
    
    @IBOutlet weak var monthGoalTextField: HMBaseTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismissView(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeUserInfo(_ sender: Any) {
    }
}
