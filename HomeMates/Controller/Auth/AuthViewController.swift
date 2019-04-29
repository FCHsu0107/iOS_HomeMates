//
//  AuthViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class AuthViewController: HMBaseViewController {

    @IBOutlet weak var authTopView: UIImageView!
    
    @IBOutlet weak var authBottomView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var checkTextField: UITextField!
    
    @IBOutlet weak var checkTextLbl: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var enterbtnLbl: UILabel!
    
    @IBOutlet weak var authViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var selectionBarBtn: [UIButton]!
    
    @IBOutlet weak var authInfoView: UIView! {
        didSet {
            HMCornerRadius.shared.setLayer(view: authInfoView, cornerRadius: 10)
        }
    }
    
    @IBOutlet weak var selectMovingBar: UIView! {
        didSet {
            selectMovingBar.layer.cornerRadius = 18
        }
    }
    
    @IBOutlet weak var selectMovingBarCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var enterButton: UIButton! {
        didSet {
            HMCornerRadius.shared.setLayer(view: enterButton, cornerRadius: 18)
        }
    }
    
    @IBOutlet weak var selectModeBackgroundView: UIView! {
        didSet {
            HMCornerRadius.shared.setLayer(view: selectModeBackgroundView, cornerRadius: 18)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StatusBarSettings.setBackgroundColor(color: UIColor.clear)
    }

    @IBAction func onChangeStatus(_ sender: UIButton) {

        for btn in selectionBarBtn {
            btn.isSelected = false
        }
        sender.isSelected = true
        
        moveSelectionBarView(reference: sender)
    }
    
    private func setSignUpMode() {
        authTopView.tintColor = UIColor.P1
        authBottomView.tintColor = UIColor.Y2
        enterButton.backgroundColor = UIColor.Y2
        enterbtnLbl.text = "創建新帳號"
        checkTextField.isHidden = false
        checkTextLbl.isHidden = false
        userNameTextField.isHidden = false
        userNameLabel.isHidden = false
        authViewConstraint.constant = 350
        selectMovingBar.backgroundColor = UIColor.P1
    }
    
    private func setLogInMode() {
        authTopView.tintColor = UIColor.Y2
        authBottomView.tintColor = UIColor.P1
        enterButton.backgroundColor = UIColor.P1
        enterbtnLbl.text = "開始旅程"
        checkTextField.isHidden = true
        checkTextLbl.isHidden = true
        userNameTextField.isHidden = true
        userNameLabel.isHidden = true
        authViewConstraint.constant = 230
        selectMovingBar.backgroundColor = UIColor.Y2
        
    }

    private func moveSelectionBarView(reference: UIButton) {
        selectMovingBarCenterXConstraint.isActive = false
        selectMovingBarCenterXConstraint = selectMovingBar.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
        selectMovingBarCenterXConstraint.isActive = true

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
            if reference.tag == 0 {
                self?.setSignUpMode()
            } else {
                self?.setLogInMode()
            }
            self?.view.layoutIfNeeded()
            }, completion: nil)
       

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectGroupSegue" {
            guard segue.destination is GroupSelectionViewController else { return }
        }
    }
    
    @IBAction func enterBtnAction(_ sender: Any) {
        if selectionBarBtn[0].isSelected == true {
            if emailTextField.text?.isEmpty == true
                || userNameLabel.text?.isEmpty == true
                || userNameLabel.text?.isEmpty == true {

                AlertService.sigleActionAlert(title: "錯誤", message: "請填寫基本資料", clickTitle: "收到", showInVc: self)
                
            } else if passwordTextField.text != checkTextField.text || passwordTextField.text?.isEmpty == true {

                AlertService.sigleActionAlert(title: "錯誤", message: "請確認密碼無誤", clickTitle: "收到", showInVc: self)
                
            } else {
                createUserDoc()
            }
            
        } else {
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
                AlertService.sigleActionAlert(title: "錯誤", message: "請輸入帳號或密碼", clickTitle: "收到", showInVc: self)
            } else {
              signInAction()
            }
        }
    }
    
    private func createUserDoc() {
        FIRAuthService.shared.createUser(withEmail: emailTextField.text!,
                                         password: passwordTextField.text!) { [weak self] (user, error) in
            if error == nil {
                guard let user = user else { return }
                let newUser = UserObject(docId: nil,
                                         name: (self?.userNameTextField.text)!,
                                         email: (user.email)!,
                                         picture: nil,
                                         creator: false,
                                         application: false,
                                         finishSignUp: false,
                                         mainGroupId: nil)
                UserDefaultManager.shared.userUid = user.uid
                FIRFirestoreSerivce.shared.createUser(uid: user.uid,
                                                      for: newUser,
                                                      in: .users)
                self?.performSegue(withIdentifier: "selectGroupSegue", sender: nil)
            } else {
                AlertService.sigleActionAlert(title: "錯誤",
                                           message: error?.localizedDescription,
                                           clickTitle: "收到",
                                           showInVc: self!)
            }
        }
    }
    
    private func signInAction() {
        FIRAuthService.shared.signIn(withEmail: emailTextField.text!,
                                     password: passwordTextField.text!) { [weak self] (error) in
            if error == nil {
                FIRFirestoreSerivce.shared.findUser { [weak self] bool, userInfo  in
                    if bool == true && userInfo?.mainGroupId != nil {
                        UserDefaultManager.shared.groupId = userInfo?.mainGroupId
                        let tabBarVC = UIStoryboard.main.instantiateInitialViewController()!
                        self?.present(tabBarVC, animated: true, completion: nil)
                    } else {
                        if let selectGroupVc =
                            UIStoryboard.auth.instantiateViewController(
                                withIdentifier: String(describing: GroupSelectionViewController.self))
                                as? GroupSelectionViewController {
                            
                            self?.present(selectGroupVc, animated: true, completion: nil)
                            
                        }
                    }
                }

            } else {
                AlertService.sigleActionAlert(title: "錯誤",
                                           message: error?.localizedDescription,
                                           clickTitle: "收到",
                                           showInVc: self!)
            }
        }
    }
    
}
