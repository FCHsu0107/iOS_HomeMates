//
//  GroupSelectionViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FirebaseAuth

class GroupSelectionViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func createAGroup(_ sender: Any) {
        if userNameTextField.text?.isEmpty == true {
            
        } else {
            guard let userName = userNameTextField.text else { return }
            guard let groupName = groupNameTextField.text else { return }
            guard let user = Auth.auth().currentUser else { return }
            let newUser = UserObject(uid: user.uid,
                                     name: userName,
                                     email: user.email!,
                                     picture: nil,
                                     selectGroup: "no yet")
            
            let newGroup = GroupObject(name: groupName, picture: "")
        
            FIRFirestoreSerivce.shared.createUser(uid: user.uid, for: newUser, in: .users)
            FIRFirestoreSerivce.shared.create(for: newGroup, in: .groups)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarVc = storyboard.instantiateViewController(
                withIdentifier: String(describing: HMTabBarViewController.self))
                as? HMTabBarViewController {
                self.present(tabBarVc, animated: true, completion: nil)
            }
        }
    }
}
