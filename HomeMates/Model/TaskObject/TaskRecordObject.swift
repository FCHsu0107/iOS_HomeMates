//
//  TaskRecord.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct TaskTracker: Codable {

    var docId: String?
    
    let taskName: String

    let taskImage: String?

    let executorName: String
    
    let executorId: String

    var totalPoints: Int

    var taskTimes: Int
    
    enum CodingKeys: String, CodingKey {
        
        case docId
        
        case taskName
        
        case taskImage
        
        case executorName
        
        case totalPoints
        
        case taskTimes
        
        case executorId
    }
    
}
