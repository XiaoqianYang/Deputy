//
//  SwiftAPI.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation

class ShiftAPI {
    static let shared = ShiftAPI()
    private init() {}
    
    func getShiftList() -> [String : [Shift]] {
        let shift1 = Shift.init(startTime : Date.MyDateFromISOString(string: "2017-01-16T06:35:57+00:00"), endTime:Date.MyDateFromISOString(string:""), startLocation: nil, endLocation: nil, icon: "")
        let shift2 = Shift.init(startTime : Date.MyDateFromISOString(string: "2017-01-16T06:35:57+00:00"), endTime:Date.MyDateFromISOString(string: "2017-01-16T18:42:12+00:00"), startLocation: nil, endLocation: nil, icon: "")
        let shiftlist1 = [shift1]
        let shiftlist2 = [shift2]
        var shifts : [String : [Shift]] = [:]
        shifts["processing"] = shiftlist1
        shifts["finished"] = shiftlist2
        
        
        return shifts
    }
}

public extension Date {
    static func MyDateFromISOString(string: String) -> String {
        let formatter8601 = ISO8601DateFormatter()
        
        if let date = formatter8601.date(from: string) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            let string = formatter.string(from: date)
            return string
        }
        else {
            return "In progress"
        }

    }
}
