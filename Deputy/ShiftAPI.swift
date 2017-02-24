//
//  SwiftAPI.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import CoreLocation

class ShiftAPI {
    static let shared = ShiftAPI()
    private init() {}
    
    func getShiftList() -> [String : [Shift]] {
        let shift1 = Shift.init(startTime : Date.DateFrom8601String(string: "2017-01-16T06:35:57+00:00"), endTime:Date.DateFrom8601String(string:""), startLocation:CLLocationCoordinate2DMake(-33.777470, 150.977880), endLocation:CLLocationCoordinate2DMake(-33.808940, 151.182920), icon: "")
        let shift2 = Shift.init(startTime : Date.DateFrom8601String(string: "2017-01-16T06:35:57+00:00"), endTime:Date.DateFrom8601String(string: "2017-01-16T18:42:12+00:00"), startLocation:CLLocationCoordinate2DMake(-33.777470, 150.977880), endLocation:CLLocationCoordinate2DMake(-33.808940, 151.182920), icon: "")
        let shiftlist1 = [shift1]
        let shiftlist2 = [shift2]
        var shifts : [String : [Shift]] = [:]
        shifts["processing"] = shiftlist1
        shifts["finished"] = shiftlist2
        
        
        return shifts
    }
    
    func endShift(shift : Shift) {
        print("End Shift: \(shift)")
    }
    
    func startShift(shift : Shift) {
        print("start Shift: \(shift)")
    }
}

extension Date {
    static func DateFrom8601String(string: String) -> Date? {
        let formatter8601 = ISO8601DateFormatter()
        
        return formatter8601.date(from: string)
    }
    
//    static func MyDateFrom8601String(string: String) -> String {
//        let formatter8601 = ISO8601DateFormatter()
//        
//        if let date = formatter8601.date(from: string) {
//            let formatter = DateFormatter()
//            formatter.dateStyle = Constants.DATE_DATESTYLE
//            formatter.timeStyle = Constants.DATE_TIMESTYLE
//            let string = formatter.string(from: date)
//            return string
//        }
//        else {
//            return "In progress"
//        }
//
//    }
    
    static func MyDateFromDate(date: Date?) -> String {
        if date == nil {
            return ""
        }
        else {
            let formatter = DateFormatter()
            formatter.dateStyle = Constants.DATE_TIMESTYLE
            formatter.timeStyle = Constants.DATE_TIMESTYLE
            let string = formatter.string(from: date!)
            return string
        }
    }
}



