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
    
    var user: UserObject?
    var goal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("_______nextVC user_______")
        print(user)
        loadUserInfo()

    }
    
    @IBAction func dismissView(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeUserInfo(_ sender: Any) {
    }
    
    func loadUserInfo() {
        guard let name = user?.name, let mainGroupId = user?.mainGroupId else { return }
        userNameTextField.text = user?.name
        ownGroupTextField.text = user?.mainGroupId
        guard let goal = goal else { return }
        monthGoalTextField.text = String(goal)
    }
}
