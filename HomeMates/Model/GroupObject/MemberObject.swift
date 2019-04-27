//
//  MemberObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct MemberObject: Codable {
    
    var docId: String?
    
    let userId: String
    
    let userName: String
    
    let isCreator: Bool
    
    let permission: Bool
    
    let userPicture: String
    
    var goal: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case userId
        
        case userName
        
        case isCreator
        
        case permission
        
        case userPicture
        
        case goal
    }
}
