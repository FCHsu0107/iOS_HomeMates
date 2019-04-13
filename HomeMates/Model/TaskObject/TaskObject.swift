//
//  TaskObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct TaskObject {

    let taskName: String

    let image: String

    let publisherName: String

    let executorName: String?

    let taskPoint: Int

    let taskPriodDay: Int
    
    let completionDate: Date?
    
    let taskStatus: Int
    
    enum CodingKeys: String, CodingKey {
        
        case taskName
        
        case image
        
        case punlisherName
        
        case executorName
        
        case taskPoint
        
        case taskPriodDay
        
        case completionDate
        
        case taskStatus
    }
}
