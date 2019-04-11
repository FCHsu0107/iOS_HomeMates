//
//  AuthViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: HMBaseViewController {

    @IBOutlet weak var authTopView: UIImageView!
    
    @IBOutlet weak var authBottomView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var checkTextField: UITextField!
    
    @IBOutlet weak var checkTextLbl: UILabel!
    
    @IBOutlet weak var enterbtnLbl: UILabel!
    
    @IBOutlet weak var authViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var selectionBarBtn: [UIButton]!
    
    @IBOutlet weak var authInfoView: UIView! {
        didSet {
            authInfoView.layer.cornerRadius = 10
            authInfoView.layer.shadowOpacity = 0.2
            authInfoView.layer.shadowOffset = CGSize(width: 0, height: 3)
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
            enterButton.layer.cornerRadius = 18
            enterButton.layer.shadowOpacity = 0.2
            enterButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }
    
    @IBOutlet weak var selectModeBackgroundView: UIView! {
        didSet {
            selectModeBackgroundView.layer.cornerRadius = 18
            selectModeBackgroundView.layer.shadowOpacity = 0.2
            selectModeBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }
    var alertView = AlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onChangeProducts(_ sender: UIButton) {
        
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
        enterbtnLbl.text = "Create Account"
        checkTextField.isHidden = false
        checkTextLbl.isHidden = false
        authViewConstraint.constant = 290
        selectMovingBar.backgroundColor = UIColor.P1
    }
    
    private func setLogInMode() {
        authTopView.tintColor = UIColor.Y2
        authBottomView.tintColor = UIColor.P1
        enterButton.backgroundColor = UIColor.P1
        enterbtnLbl.text = "Get Started"
        checkTextField.isHidden = true
        checkTextLbl.isHidden = true
        authViewConstraint.constant = 230
        selectMovingBar.backgroundColor = UIColor.Y2
        
    }

    private func moveSelectionBarView(reference: UIButton) {
        selectMovingBarCenterXConstraint.isActive = false
        selectMovingBarCenterXConstraint = selectMovingBar.centerXAnchor.constraint(equalTo: reference.centerXAnchor)
        selectMovingBarCenterXConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if reference.tag == 0 {
                self?.setSignUpMode()
            } else {
                self?.setLogInMode()
            }
            self?.view.layoutIfNeeded()
        })
    }
    
    @IBAction func enterBtnAction(_ sender: Any) {
        if selectionBarBtn[0].isSelected == true {
            if emailTextField.text?.isEmpty == true {
                
                alertView.sigleActionAlert(title: "錯誤", message: "請輸入電子郵件", clickTitle: "收到", vc: self)
            
            } else if passwordTextField.text != checkTextField.text || passwordTextField.text?.isEmpty == true {
                
                alertView.sigleActionAlert(title: "錯誤", message: "請確認密碼無誤", clickTitle: "OK", vc: self)
                
            } else {
                Auth.auth().createUser(withEmail: emailTextField.text!,
                                       password: passwordTextField.text!) { (authResult, error) in
//                    guard let user = authResult?.user else { return }
                    if error == nil {
                        print("you have sucessfully signed up")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                if let tabBarVC =
                                    storyboard.instantiateViewController(
                                        withIdentifier: String(describing: HMTabBarViewController.self))
                                        as? HMTabBarViewController {
                                    self.present(tabBarVC, animated: true, completion: nil)
                                }
                    } else {
                        self.alertView.sigleActionAlert(title: "錯誤",
                                                        message: error?.localizedDescription,
                                                        clickTitle: "OK", vc: self)
                    }
                }
            }
            
        } else {
                
            }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let tabBarVC =
//            storyboard.instantiateViewController(
//                withIdentifier: String(describing: HMTabBarViewController.self)) as? HMTabBarViewController {
//            self.present(tabBarVC, animated: true, completion: nil)
//        }
    }
}
