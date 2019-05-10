//
//  FIRAuth.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FIRAuthManager {
    
    private init() {}
    
    static let shared = FIRAuthManager()
    
    func createUser(withEmail: String,
                    password: String,
                    completion: @escaping (User?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { (auth, err) in
            if err == nil {
                guard let user = auth?.user else { return completion(nil, err) }
                completion(user, err)
            } else {
                completion(nil, err)
            }
        }
    }
    
    func signIn(withEmail: String,
                password: String,
                completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { (_, err) in
            if err == nil {
                completion(nil)
            } else {
                completion(err)
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        
    }
    
    func addSignUpListener(listener: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            guard let user = user else {
                // 登出
                UserDefaults.standard.removeObject(forKey: UserDefaultManager.shared.userDefaultGroupID)
                UserDefaults.standard.removeObject(forKey: UserDefaultManager.shared.userDefaultUserUid)
                
                listener(false)
                
                return
            }
            // 登入
            UserDefaultManager.shared.userUid = user.uid
            listener(true)
        }
    }
    
}

extension FIRAuthManager {
    
    // Auth page - sign up and log in
    func createUserDoc(email: String,
                       password: String,
                       userName: String,
                       completion: @escaping (Bool, Error?) -> Void) {
        FIRAuthManager.shared.createUser(withEmail: email,
                                         password: password) {(user, error) in
            if error == nil {
                guard let user = user else { return }
                let newUser = UserObject(docId: nil,
                                         name: userName,
                                         email: (user.email)!,
                                         picture: nil,
                                         creator: false,
                                         application: false,
                                         finishSignUp: false,
                                         mainGroupId: nil,
                                         fcmToken: nil)
                UserDefaultManager.shared.userUid = user.uid
                FIRFirestoreSerivce.shared.createUser(uid: user.uid,
                                                      for: newUser,
                                                      in: .users)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //Auth page - log in
    func signInAction(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        FIRAuthManager.shared.signIn(withEmail: email, password: password) { (error) in
            if error == nil {
                FIRFirestoreSerivce.shared.findUser { bool, userInfo  in
                    if bool == true && userInfo?.mainGroupId != nil {
                            UserDefaultManager.shared.groupId = userInfo?.mainGroupId
                            completion(true, nil)
                        } else {
                            completion(false, nil)
                        
                        }
                    }
                } else {
                completion(false, error)
            }
        }
    }

}
