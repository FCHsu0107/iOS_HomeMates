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
    
    @IBOutlet weak var ownGroupIDTextField: HMBaseTextField!
    
    @IBOutlet weak var monthGoalTextField: HMBaseTextField!
    
    let profileProvider = ProfileProvider()
    
    var user: UserObject?
    
    var groupInfo: GroupObject?
    
    var goal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirestoreGroupManager.shared.readGroupInfo { [weak self] (object) in
            self?.groupInfo = object
            self?.ownGroupTextField.text = object.name
            self?.ownGroupIDTextField.text = object.groupId
        }
        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func changeUserInfo(_ sender: Any) {
        guard let userName = userNameTextField.text else { return }
        guard let goal = monthGoalTextField.text else {
            FirestoreUserManager.shared.updateUserInfo(newName: userName, goal: nil)
            NotificationCenter.default.post(
                name: Notification.Name(NotificationName.changeUserInfo.rawValue), object: nil)
            HMProgressHUD.showSuccess(text: "修改成功")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popToRootViewController(animated: false)
            }
            return
        }
        
        FirestoreUserManager.shared.updateUserInfo(newName: userName, goal: Int(goal))
        NotificationCenter.default.post(
            name: Notification.Name(NotificationName.changeUserInfo.rawValue), object: nil)
        HMProgressHUD.showSuccess(text: "修改成功")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToRootViewController(animated: false)
        }
        
    }
    
    private func loadUserInfo() {
        guard let name = user?.name else { return }
        
        userNameTextField.text = name
        guard let goal = goal else { return }
        monthGoalTextField.text = String(goal)
        guard let mainGroupId = groupInfo?.name,
            let mainGroupID = groupInfo?.groupId else { return }
        ownGroupTextField.text = mainGroupId
        ownGroupIDTextField.text = mainGroupID
       
    }
    
    @IBAction func dropOutMainGroup(_ sender: Any) {
        profileProvider.readMemberInfo { [weak self] (result) in
            switch result {
            case .success(let members):
                StatusBarSettings.statusBarForAlertView()
                let alertSheet = UIAlertController.dropOutGroupActionSheet(
                    memberNumber: members.count, completion: { (flag) in
                    if flag == true {
                        self?.profileProvider.dropOutMainGroup(memberNumber: members.count, completion: { (flag) in
                            if flag == true {
                                if let selectGroupVc =
                                    UIStoryboard.auth.instantiateViewController(
                                        withIdentifier: String(describing: GroupSelectionViewController.self))
                                        as? GroupSelectionViewController {
                                    
                                    self?.present(selectGroupVc, animated: true, completion: nil)
                                    StatusBarSettings.setBackgroundColor(color: .clear)
                                }
                            } else {
                                print("刪除資料發生錯誤")
                            }
                        })
                        
                    }
                    
                })
                self?.present(alertSheet, animated: false, completion: nil)
                
            case .failure:
                break
            }
        }
        
    }
    
}
