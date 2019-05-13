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
    
    @IBOutlet weak var authInfoView: UIView!
    
    @IBOutlet weak var selectMovingBar: UIView!
    
    @IBOutlet weak var selectMovingBarCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var selectModeBackgroundView: UIView! 
    
    let authProvider = AuthProvider()
    
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

                let alert = UIAlertController.sigleActionAlert(
                    title: "注意", message: "請確實填寫基本資料", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)
                
            } else if passwordTextField.text != checkTextField.text || passwordTextField.text?.isEmpty == true {
                let alert = UIAlertController.sigleActionAlert(
                    title: "注意", message: "請確認密碼無誤", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)
            } else {
                createUserDoc()
            }
            
        } else {
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
                let alert = UIAlertController.sigleActionAlert(
                    title: "注意", message: "請輸入帳號或密碼", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)
            } else {
              signInAction()
            }
        }
    }
    
    private func createUserDoc() {
        authProvider.createUserDoc(
        email: emailTextField.text!, password: passwordTextField.text!,
        userName: userNameTextField.text!) { [weak self] (result) in
            switch result {
            
            case .success(_):
                self?.performSegue(withIdentifier: "selectGroupSegue", sender: nil)
                
            case .failure(let error):
                let alert = UIAlertController.sigleActionAlert(
                    title: "發生錯誤", message: error.localizedDescription, clickTitle: "收到")
                self?.present(alert, animated: false, completion: nil)
            }
        }
    }
    
    private func signInAction() {
        authProvider.signInAction(email: emailTextField.text!,
                                  password: passwordTextField.text!) { [weak self] (result) in
            switch result {
            case .success(let flag):
                if flag == true {
                    let tabBarVC = UIStoryboard.main.instantiateInitialViewController()!
                    self?.present(tabBarVC, animated: true, completion: nil)
                } else {
                    if let selectGroupVc = UIStoryboard.auth.instantiateViewController(
                        withIdentifier: String(describing: GroupSelectionViewController.self))
                        as? GroupSelectionViewController {
                        self?.present(selectGroupVc, animated: true, completion: nil)
                    }

                }
            case .failure(let error):
                let alert = UIAlertController.sigleActionAlert(
                    title: "錯誤", message: error.localizedDescription, clickTitle: "收到")
                
                self?.present(alert, animated: false, completion: nil)
            }
        }

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
    
}
