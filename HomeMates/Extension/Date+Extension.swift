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
    
    func strartOfMonth() -> Int! {
        let firstMonthDate = Calendar.current
            .date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
        let timeStamp = firstMonthDate.timeIntervalSince1970
        return Int(timeStamp * 1000)
    }

}
