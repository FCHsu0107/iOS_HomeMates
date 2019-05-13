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

    @IBOutlet weak var baseInfoLbl: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var selectGroupView: UIView!
    
    @IBOutlet weak var movingSelectView: UIView!
    
    @IBOutlet weak var movingViewXContraint: NSLayoutConstraint!
    
    @IBOutlet weak var enterBtn: UIButton!
    
    @IBOutlet weak var firstGroupTextLbl: UILabel!
    
    @IBOutlet weak var secondGroupTextLbl: UILabel!
    
    @IBOutlet weak var firstGroupIDTextField: UITextField!
    
    @IBOutlet weak var secondGroupTextField: UITextField!
    
    @IBOutlet var selectGroupBtn: [UIButton]!
    
    let authProvider = AuthProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var dispatchGroup = DispatchGroup()
    
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
                self?.firstGroupTextLbl.text = "搜尋群組代碼"
                self?.secondGroupTextLbl.isHidden = true
                self?.secondGroupTextField.isHidden = true
            } else {
                self?.firstGroupTextLbl.text = "創立群組代碼 (供搜尋用)"
                self?.secondGroupTextLbl.isHidden = false
                self?.secondGroupTextField.isHidden = false
            }
            self?.view.layoutIfNeeded()
        })
    }
    
    @IBAction func startAppBtnAction(_ sender: Any) {
        if selectGroupBtn[0].isSelected == true {
            if firstGroupIDTextField.text?.isEmpty == true {
                let alert = UIAlertController.sigleActionAlert(title: "注意", message: "請確認資料都已填寫", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)
            } else {
                searchTheGroup()
            }
                
        } else if selectGroupBtn[1].isSelected == true {
            if firstGroupIDTextField.text?.isEmpty == true ||
                secondGroupTextField.text?.isEmpty == true {
                let alert = UIAlertController.sigleActionAlert(title: "注意", message: "請確認資料都已填寫", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)

            } else {
                guard let groupId = firstGroupIDTextField.text else { return }
                FIRFirestoreSerivce.shared.findGroup(groupId: groupId, returning: GroupObject.self) { groups, _  in
                    if groups.count == 0 {
                        self.createANewGroup()
                    } else {
                        let alert = UIAlertController.sigleActionAlert(
                            title: "群組代碼已存在", message: "請輸入其他代碼", clickTitle: "收到")
                        self.present(alert, animated: false, completion: nil)
                        
                    }
                }
            }
        }
    }
    
    func createANewGroup() {
        authProvider.createANewGroup(groupName: secondGroupTextField.text!,
                                     groupId: firstGroupIDTextField.text!) { [weak self] (result) in
            switch result {
            case .success(_):
                let tabBarVc = UIStoryboard.main.instantiateInitialViewController()!
                self?.present(tabBarVc, animated: true, completion: nil)
            default: break
            }
        }
    }
    
    func searchTheGroup() {
        authProvider.searchTheGroup(groupId: firstGroupIDTextField.text!, ownVc: self)
    }
    
}
