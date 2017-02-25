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
    
    func getShiftList(comletion:@escaping (_ shifts: [String : [Shift]])->Void){
        ShiftClient.shared.getShiftListFromServer(comletion:{
         shifts in
            comletion(self.formatShiftsListToTableDataSource(shifts: shifts))
        })
    }
    
    func endShift(shift : Shift) {
        print("End Shift: \(shift)")
    }
    
    func startShift(shift : Shift) {
        ShiftClient.shared.startShiftOnServer(shift: shift)
        print("start Shift: \(shift)")
    }
    
    func formatShiftsListToTableDataSource(shifts: [Shift]) -> [String:[Shift]] {
        var dataSource = [String : [Shift]]()
        var inprogressShift = [Shift]()
        var finishedShift = [Shift]()
        for(_, item) in shifts.enumerated() {
            if item.endTime == nil {
                inprogressShift.append(item)
            }
            else {
                finishedShift.append(item)
            }
        }
        dataSource["InProgress"] = inprogressShift
        dataSource["Finished"] = finishedShift
        
        return dataSource
    }
}

extension Date {
    static func DateFrom8601String(string: String) -> Date? {
        let formatter8601 = ISO8601DateFormatter()
        
        return formatter8601.date(from: string)
    }
    static func DateTo8601String(date: Date) -> String? {
        let formatter8601 = ISO8601DateFormatter()
        
        return formatter8601.string(from: date)
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



