//
//  ApplicationObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/15.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct ApplicationObject: Codable, Identifiable {
    
    var docId: String? 
    
    let applicantId: String
    
    let groupCreator: String
    
    let groupId: String
    
    let applicantName: String
    
    enum CodingKeys: String, CodingKey {
        
        case docId 
        
        case applicantId
        
        case groupCreator
        
        case groupId
        
        case applicantName
    }
}
