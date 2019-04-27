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
    
    @IBOutlet weak var ownGroupTextField: HMBaseTextField! {
        didSet {
            monthGoalTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var monthGoalTextField: HMBaseTextField!
    
    var user: UserObject?
    var goal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    @IBAction func changeUserInfo(_ sender: Any) {
        guard let userName = userNameTextField.text else { return }
        guard let goal = monthGoalTextField.text else {
            FirestoreUserManager.shared.updateUserInfo(newName: userName, goal: nil)
            navigationController?.popToRootViewController(animated: false)
            return
        }
        
        FirestoreUserManager.shared.updateUserInfo(newName: userName, goal: Int(goal))
        navigationController?.popToRootViewController(animated: false)

    }
    
    func loadUserInfo() {
        guard let name = user?.name, let mainGroupId = user?.mainGroupId else { return }
        userNameTextField.text = name
        ownGroupTextField.text = mainGroupId
        guard let goal = goal else { return }
        monthGoalTextField.text = String(goal)
    }
}
