//
//  TaskObject.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

struct TaskObject: Codable, Identifiable {
    
    var docId: String?

    let taskName: String

    let image: String

    let publisherName: String

    var executorName: String?
    
    var executorUid: String?

    let taskPoint: Int

    let taskPriodDay: Int
    
    var compleyionTimeStamp: Int?
    
    var completionDate: String?
    
    var taskStatus: Int
    
    enum CodingKeys: String, CodingKey {
        
        case docId 
        
        case taskName
        
        case image
        
        case publisherName
        
        case executorName
        
        case taskPoint
        
        case taskPriodDay
        
        case compleyionTimeStamp
        
        case completionDate
        
        case taskStatus
        
        case executorUid

    }
}
