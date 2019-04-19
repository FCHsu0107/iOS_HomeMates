//
//  Date+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/19.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

extension Date {
    func toMillis() -> Int! {
        return Int(self.timeIntervalSince1970 * 1000)
    }

}
