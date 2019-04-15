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

    @IBOutlet weak var baseInfoLbl: UILabel! {
        didSet {
            HMCornerRadius.shared.setLayer(view: baseInfoLbl, cornerRadius: 18)
        }
    }
    @IBOutlet weak var backgroundView: UIView! {
        didSet {
            HMCornerRadius.shared.setLayer(view: backgroundView, cornerRadius: 10)
        }
    }
    
    @IBOutlet weak var selectGroupView: UIView! {
        didSet {
            HMCornerRadius.shared.setLayer(view: selectGroupView, cornerRadius: 18)
        }
    }
    
    @IBOutlet weak var movingSelectView: UIView! {
        didSet {
            movingSelectView.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var movingViewXContraint: NSLayoutConstraint!
    
    @IBOutlet weak var enterBtn: UIButton! {
        didSet {
            HMCornerRadius.shared.setLayer(view: enterBtn, cornerRadius: 18)
        }
    }
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var searchGroupIDTextField: UITextField!
    
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet var selectGroupBtn: [UIButton]!
    
    var alertView = AlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onChangeInfo(_ sender: UIButton) {
        for btn in selectGroupBtn {
            btn.isSelected = false
        }
        sender.isSelected = true
        
        moveSelectionBarView(reference: sender)
    }
    
    private func moveSelectionBarView(reference: UIButton) {
        movingViewXContraint.isActive = false
        movingViewXContraint = movingSelectView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
        movingViewXContraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if reference.tag == 0 {
                self?.groupNameTextField.isEnabled = false
                self?.searchGroupIDTextField.isEnabled = true
            } else {
                self?.groupNameTextField.isEnabled = true
                self?.searchGroupIDTextField.isEnabled = false
            }
            self?.view.layoutIfNeeded()
        })
    }
    
    @IBAction func startAppBtnAction(_ sender: Any) {
        if selectGroupBtn[0].isSelected == true {
            
        } else {
            if userNameTextField.text?.isEmpty == true {
                alertView.sigleActionAlert(title: "注意", message: "請輸入群組名稱", clickTitle: "收到", showInVc: self)
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
}
