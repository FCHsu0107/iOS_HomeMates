//
//  MonthsObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/23.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct MonthObject: Codable {
    
    var docId: String?
    
    let month: String
    
    let goal: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case month
        
        case goal
    }
}
