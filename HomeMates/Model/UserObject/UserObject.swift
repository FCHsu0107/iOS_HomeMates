//
//  UserObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    
    let name: String
    
    let email: String
    
    let picture: String?
    
    let creater: Bool
    
    let application: Bool?
    
    let finishSignUp: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case email
        
        case picture
        
        case creater
        
        case application
        
        case finishSignUp
    }
}
