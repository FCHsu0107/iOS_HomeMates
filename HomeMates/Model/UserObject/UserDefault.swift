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
    
    let userDefaultGroupID: String = "HomeMatesGroupId"
    
    let userDefaultUserName: String = "HomeMatesUserName"
    
    let userDefaultUserUid: String = "HomeMatesUserUid"
    
    var groupId: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultGroupID)
        }
        get {
          return UserDefaults.standard.value(forKey: userDefaultGroupID) as? String
        }
    }
    
    var userName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultUserName)
        }
        get {
            return UserDefaults.standard.value(forKey: userDefaultUserName) as? String
        }
    }
    
    var userUid: String? {
        set {
           UserDefaults.standard.set(newValue, forKey: userDefaultUserUid)
        }
        get {
            return UserDefaults.standard.value(forKey: userDefaultUserUid) as? String
        }
    }

}
