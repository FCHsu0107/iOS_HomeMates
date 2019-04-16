//
//  ApplicationObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct ApplicationObject: Codable {
    
    let applicantId: String
    
    let groupCreator: String
    
    let groupId: String
    
    enum CodingKeys: String, CodingKey {
        
        case applicantId
        
        case groupCreator
        
        case groupId
    }
}