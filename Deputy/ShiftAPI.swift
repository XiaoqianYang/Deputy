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
            var shiftToReturn = [String : [Shift]]()
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
            shiftToReturn["InProgress"] = inprogressShift
            shiftToReturn["Finished"] = finishedShift
            comletion(shiftToReturn)
        })
//        let shift1 = Shift.init()
//        shift1.configShift(id: nil, startTime: "2017-01-16T06:35:57+00:00", endTime: "2017-01-16T18:42:12+00:00", startLatitude: "-33.777470", startLongitude: "151.182920", endLatitude: "-33.808940", endLongitude: "151.182920", icon: nil)
//        let shift2 = Shift.init()
//        shift2.configShift(id: nil, startTime: "2017-01-16T06:35:57+00:00", endTime: nil, startLatitude: "-33.777470", startLongitude: "151.182920", endLatitude: nil, endLongitude: nil, icon: nil)
//        let shiftlist1 = [shift1]
//        let shiftlist2 = [shift2]
//        var shifts : [String : [Shift]] = [:]
//        shifts["processing"] = shiftlist1
//        shifts["finished"] = shiftlist2
//        
//        
//        return shifts
    }
    
    func endShift(shift : Shift) {
        print("End Shift: \(shift)")
    }
    
    func startShift(shift : Shift) {
        ShiftClient.shared.startShiftOnServer(shift: shift)
        print("start Shift: \(shift)")
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



