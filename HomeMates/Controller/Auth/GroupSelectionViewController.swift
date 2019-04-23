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
    
    @IBOutlet weak var firstGroupTextLbl: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var secondGroupTextLbl: UILabel!
    
    @IBOutlet weak var firstGroupIDTextField: UITextField!
    
    @IBOutlet weak var secondGroupTextField: UITextField!
    
    @IBOutlet var selectGroupBtn: [UIButton]!
    
//    var alertView = AlertService()
    
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
                self?.firstGroupTextLbl.text = "搜尋群組 ID"
                self?.secondGroupTextLbl.isHidden = true
                self?.secondGroupTextField.isHidden = true
            } else {
                self?.firstGroupTextLbl.text = "創立群組 ID"
                self?.secondGroupTextLbl.isHidden = false
                self?.secondGroupTextField.isHidden = false
            }
            self?.view.layoutIfNeeded()
        })
    }
    
    @IBAction func startAppBtnAction(_ sender: Any) {
        if selectGroupBtn[0].isSelected == true {
            if firstGroupIDTextField.text?.isEmpty == true || userNameTextField.text?.isEmpty == true {
                AlertService.sigleActionAlert(title: "注意", message: "請確認基本資料都已填寫", clickTitle: "收到", showInVc: self)
            } else {
                searchTheGroup()
            }
                
        } else if selectGroupBtn[1].isSelected == true {
            if userNameTextField.text?.isEmpty == true ||
                firstGroupIDTextField.text?.isEmpty == true ||
                secondGroupTextField.text?.isEmpty == true {
                AlertService.sigleActionAlert(title: "注意", message: "請確認基本資料都已填寫", clickTitle: "收到", showInVc: self)

            } else {
                guard let groupId = firstGroupIDTextField.text else { return }
                FIRFirestoreSerivce.shared.findGroup(groupId: groupId, returning: GroupObject.self) { groups, _  in
                    if groups.count == 0 {
                        self.createANewGroup()
                    } else {
                        AlertService.sigleActionAlert(title: "群組 ID 已存在",
                                                   message: "請選擇其他 ID",
                                                   clickTitle: "收到",
                                                   showInVc: self)
                    }
                }
            }
        }
    }
    
    func createANewGroup() {
        guard let userName = userNameTextField.text else { return }
        guard let groupName = secondGroupTextField.text else { return }
        guard let user = Auth.auth().currentUser else { return }
        guard let groupId = firstGroupIDTextField.text else { return }

        let newGroup = GroupObject(docId: nil,
                                   creatorId: user.uid,
                                   createrName: userName,
                                   name: groupName,
                                   picture: nil,
                                   shortcup: " ",
                                   groupId: groupId)
        
        FIRFirestoreSerivce.shared.createGroup(for: newGroup, in: .groups)
        
        let newUser = UserObject(docId: nil,
                                 name: userName,
                                 email: user.email!,
                                 picture: nil,
                                 creator: true,
                                 application: false,
                                 finishSignUp: true,
                                 mainGroupId: UserDefaultManager.shared.groupId!)
        
        FIRFirestoreSerivce.shared.createUser(uid: user.uid, for: newUser, in: .users)
        
        let groupInfoInUser = GroupInfoInUser(docId: UserDefaultManager.shared.groupId!,
                                              isMember: true,
                                              groupID: UserDefaultManager.shared.groupId!,
                                              groupName: groupName,
                                              isMainGroup: true)
        
        FirestoreUserManager.shared.createGroupInUser(for: groupInfoInUser)
        
        let groupMemnber = MemberObject(docId: nil,
                                        userId: user.uid,
                                        userName: userName,
                                        isCreator: true,
                                        permission: true,
                                        userPicture: "Profile_80px")
        
        FIRFirestoreSerivce.shared.createSub(for: groupMemnber,
                                             in: .groups,
                                             inDocument: UserDefaultManager.shared.groupId!,
                                             inNext: .members)
 
        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
        self.present(tabBarVc, animated: true, completion: nil)
    }
    
    func searchTheGroup() {
        guard let userName = userNameTextField.text else { return }
        guard let user = Auth.auth().currentUser else { return }
        
        var groupResults: [GroupObject] = []
        var creatorNames: [String] = []
        var groupNames: [String] = []
        
        guard let groupId = firstGroupIDTextField.text else { return }
        FIRFirestoreSerivce.shared.findGroup(groupId: groupId, returning: GroupObject.self) { groups, docIds  in
            if groups.count == 0 {
                AlertService.sigleActionAlert(title: "群組不存在",
                                              message: "請確認群組 ID 或創立新群組",
                                              clickTitle: "收到",
                                              showInVc: self)
            } else {
                for index in groups {
                    creatorNames.append(index.createrName)
                    groupResults.append(index)
                    groupNames.append(index.name)
                }
   
                let alertSheet =
                    UIAlertController.showAlertSheet(title: "確認加入群組",
                                                     message: "確認群組名稱",
                                                     action: groupNames) { (index) in
                        groupResults[index].docId = UserDefaultManager.shared.groupId
                        let memberInfo = MemberObject(docId: nil,
                                                      userId: user.uid,
                                                      userName: userName,
                                                      isCreator: false,
                                                      permission: false,
                                                      userPicture: "Profile_80px")
                        
                        FIRFirestoreSerivce.shared.createSub(for: memberInfo,
                                                             in: .groups,
                                                             inDocument: docIds[index],
                                                             inNext: .members)
                        
                        let newUser = UserObject(docId: nil,
                                                 name: userName,
                                                 email: user.email!,
                                                 picture: nil,
                                                 creator: false,
                                                 application: false,
                                                 finishSignUp: true,
                                                 mainGroupId: docIds[index])
                        
                        FIRFirestoreSerivce.shared.createUser(uid: user.uid, for: newUser, in: .users)
                        
                        let groupInfoInUser = GroupInfoInUser(docId: nil,
                                                              isMember: false,
                                                              groupID: docIds[index],
                                                              groupName: groupResults[index].name,
                                                              isMainGroup: true)

                        FirestoreUserManager.shared.createGroupInUser(for: groupInfoInUser)
                        
                        let application = ApplicationObject(docId: nil,
                                                            applicantId: user.uid,
                                                            groupCreator: groupResults[index].creatorId,
                                                            groupId: docIds[index],
                                                            applicantName: userName)
                        
                        FIRFirestoreSerivce.shared.createGroup(for: application, in: .applications)
                        
                        FIRFirestoreSerivce.shared.upadeSingleStatus(uid: groupResults[index].creatorId,
                                                                     in: .users,
                                                                     status: UserObject.CodingKeys.application.rawValue,
                                                                     bool: true)
                        
                        let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
                        self.present(tabBarVc, animated: true, completion: nil)
                
                }
                
                self.present(alertSheet, animated: true, completion: nil)
            }
        }
    }
    
    func applyToJoinAGroup() {
        
    }
}
