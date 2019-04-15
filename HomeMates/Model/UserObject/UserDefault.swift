//
//  UserDefault.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    let userDefaultUserID: String = "HomeMatesUserUid"
    
    let userDefaultGroupID: String = "HomeMatesGroupId"
    
    var userUid: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultUserID)
        }
        get {
            return UserDefaults.standard.value(forKey: userDefaultUserID) as? String
        }
    }
    
    var groupId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultGroupID)
        }
        get {
          return UserDefaults.standard.value(forKey: userDefaultGroupID) as? String
        }
    }
    
}
