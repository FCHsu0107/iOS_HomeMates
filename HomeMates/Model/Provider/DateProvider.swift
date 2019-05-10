//
//  DateProvider.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/19.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation

class DateProvider {
    
    static let shared = DateProvider()
    
    func getTimeStamp() -> Int {
        let currentTimeStamp = Date().toMillis()
        return currentTimeStamp!
    }
    
    func getCurrentDate(currentTimeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(currentTimeStamp)/1000)
        let outputFormat = DateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier: "en_US") as Locale
        outputFormat.dateFormat = "yyyy/MM/dd"
        
        return outputFormat.string(from: date as Date)
    }

    func getCurrentDate() -> String {
        let currentTimeStamp = Date().toMillis()
        let date = Date(timeIntervalSince1970: Double(currentTimeStamp!)/1000)
        let outputFormat = DateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier: "en_US") as Locale
        outputFormat.dateFormat = "yyyy/MM/dd"
        
        return outputFormat.string(from: date as Date)
    }
    
    func getCurrentMonths() -> String {
        let currentTimeStamp = getTimeStamp()
        let date = Date(timeIntervalSince1970: Double(currentTimeStamp)/1000)
        let outputFormat = DateFormatter()
        outputFormat.locale = NSLocale(localeIdentifier: "en_US") as Locale
        outputFormat.dateFormat = "yyyy/MM"
        
        return outputFormat.string(from: date as Date)
    }
    
}