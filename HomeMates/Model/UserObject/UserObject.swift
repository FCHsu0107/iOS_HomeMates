//
//  UserObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/13.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    
    var docId: String?
    
    let name: String
    
    let email: String
    
    let picture: String?
    
    let creator: Bool
    
    let application: Bool
    
    let finishSignUp: Bool
    
    var mainGroupId: String?
 
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case name
        
        case email
        
        case picture
        
        case creator
        
        case application
        
        case finishSignUp
        
        case mainGroupId

    }
}
