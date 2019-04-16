//
//  GroupObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct GroupObject: Codable {
    
    let createrId: String
    
    let createrName: String
    
    let name: String
    
    let picture: String?
    
    var shortcup: String
    
    let groupId: String
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case picture
        
        case createrId
        
        case createrName
        
        case shortcup
        
        case groupId
    }
}
