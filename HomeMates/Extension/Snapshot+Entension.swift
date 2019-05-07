//
//  Snapshot+Entension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
        
        let documentJson = data()
    
        let documentData = try JSONSerialization.data(withJSONObject: documentJson as Any,
                                                      options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
    
}
