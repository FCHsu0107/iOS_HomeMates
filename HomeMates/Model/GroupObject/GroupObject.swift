//
//  GroupObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct GroupObject: Codable {
    
    let creater: String
    
    let name: String
    
    let picture: String?
    
    enum CodingKeys: String, CodingKey {
        
        case name
        
        case picture
        
        case creater
        
    }
}
