//
//  GroupObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

protocol Identifiable {
    var docId: String? { get set }
}

struct GroupObject: Codable, Identifiable {
    
    var docId: String?
    
    let creatorId: String
    
    let createrName: String
    
    let name: String
    
    let picture: String?
    
    var shortcup: String
    
    let groupId: String
    
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case name
        
        case picture
        
        case creatorId
        
        case createrName
        
        case shortcup
        
        case groupId
    }
}
