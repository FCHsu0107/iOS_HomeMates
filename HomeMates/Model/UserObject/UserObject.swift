//
//  UserObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct UserObject {
    
    let name: String
    
    let email: String
    
    let picture: String?
    
    let selectGroup: String
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case email
        
        case picture
        
        case selectGroup
        
    }
}
