//
//  Encodable+Entension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/14.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

enum HMError: Error {
    case encodingError
}

extension Encodable {
    
    func toJSON(excluding keys: [String] = [String]()) throws -> [String: Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        
        guard var json = jsonObject as? [String: Any] else { throw HMError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        return json
    }
}
