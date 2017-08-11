//
//  HEDatePickerExtensions.swift
//  HEDatePicker
//
//  Created by Hassan on 8/11/17.
//  Copyright © 2017 hassaneskandari. All rights reserved.
//

import Foundation

public extension Date {

    func hour() -> Int {
        let hour = Calendar.current.component(.hour, from: self)
        return hour
    }
    func minute() -> Int {
        let minute = Calendar.current.component(.minute, from: self)
        return minute
    }

    func day() -> Int {
        let day = Calendar.current.component(.day, from: self)
        return day
    }
    func month() -> Int {
        let month = Calendar.current.component(.month, from: self)
        return month
    }
    func year() -> Int {
        let year = Calendar.current.component(.year, from: self)
        return year
    }
    
    func jalaali() -> JalaaliDate {
        return toJalaali(gy: year(), month(), day())
    }
}


public extension String {
    func changeNumbers() -> String {
        
        var str = self
        let numbersDictionary = ["1": "۱",
                                 "2": "۲",
                                 "3": "۳",
                                 "4": "۴",
                                 "5": "۵",
                                 "6": "۶",
                                 "7": "۷",
                                 "8": "۸",
                                 "9": "۹",
                                 "0": "۰"]
        
        for key in numbersDictionary.keys {
            str = str.replacingOccurrences(of: key, with: numbersDictionary[key]!)
        }
        
        return str
    }
}
