//
//  Array+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/24.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        
        return result
    }
}
