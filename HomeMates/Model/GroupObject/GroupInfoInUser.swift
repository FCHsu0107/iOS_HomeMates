//
//  GroupInfoInUser.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct GroupInfoInUser: Codable, Identifiable {
    
    var docId: String?
    
    let isMember: Bool
    
    let groupID: String
    
    let groupName: String
    
    let isMainGroup: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case isMember
        
        case groupID
        
        case groupName
        
        case isMainGroup
    }
}
