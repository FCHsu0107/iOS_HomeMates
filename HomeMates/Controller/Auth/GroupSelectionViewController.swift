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
            if searchGroupIDTextField.text?.isEmpty == true {
                alertView.sigleActionAlert(title: "注意",
                                           message: "請輸入群組名稱",
                                           clickTitle: "收到",
                                           showInVc: self)
            } else {
                searchTheGroup()
            }
                
        } else if selectGroupBtn[1].isSelected == true {
            if userNameTextField.text?.isEmpty == true {
                alertView.sigleActionAlert(title: "注意",
                                           message: "請輸入群組名稱",
                                           clickTitle: "收到",
                                           showInVc: self)
            } else {
                createANewGroup()
            }
        }
    }
    
    func createANewGroup() {
        guard let userName = userNameTextField.text else { return }
        guard let groupName = groupNameTextField.text else { return }
        guard let user = Auth.auth().currentUser else { return }

        var newGroup = GroupObject(createrId: user.uid,
                                   createrName: userName,
                                   name: groupName,
                                   picture: nil,
                                   groupId: " ")
        
        FIRFirestoreSerivce.shared.createGroup(for: newGroup, in: .groups)
        
        let newUser = UserObject(name: userName,
                                 email: user.email!,
                                 picture: nil,
                                 creater: true,
                                 application: false,
                                 finishSignUp: true)
        
        FIRFirestoreSerivce.shared.createUser(uid: user.uid, for: newUser, in: .users)
        
        let groupInfoInUser = GroupInfoInUser(isMember: true,
                                              groupID: UserDefaultManager.shared.groupId!,
                                              isMainGroup: true)
        
        FIRFirestoreSerivce.shared.createSub(for: groupInfoInUser,
                                             in: .users,
                                             inDocument: user.uid,
                                             inNext: .groups)
        
        let groupMemnber = MemberObject(userId: user.uid,
                                        userName: userName,
                                        isCreator: true,
                                        permission: true)
        
        FIRFirestoreSerivce.shared.createSub(for: groupMemnber,
                                             in: .groups,
                                             inDocument: UserDefaultManager.shared.groupId!,
                                             inNext: .members)
        newGroup.groupId = UserDefaultManager.shared.shorterGroupID!

        FIRFirestoreSerivce.shared.createUser(uid: UserDefaultManager.shared.groupId!,
                                              for: newGroup,
                                              in: .groups)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarVc = storyboard.instantiateViewController(
            withIdentifier: String(describing: HMTabBarViewController.self))
            as? HMTabBarViewController {
            self.present(tabBarVc, animated: true, completion: nil)
        }
    }
    
    func searchTheGroup() {
        FIRFirestoreSerivce.shared.findGroup(shorterGroupId: "kBexZN",
                                             returning: GroupObject.self) { groups in
                                                print(groups)
        }
    }
    
}
