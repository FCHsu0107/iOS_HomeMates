//
//  MemberObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct MemberObject: Codable {
    
    let userId: String
    
    let userName: String
    
    let isCreator: Bool
    
    let permission: Bool
    
    enum CodingKeys: String, CodingKey {
        case userId
        
        case userName
        
        case isCreator
        
        case permission
    }
}
