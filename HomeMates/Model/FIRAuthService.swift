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

class FIRAuthService {
    
    private init() {}
    
    static let shared = FIRAuthService()
    
    func createUser(withEmail: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: completion)
    }
    
    func signIn(withEmail: String, link: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: withEmail, link: link, completion: completion)
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
}
