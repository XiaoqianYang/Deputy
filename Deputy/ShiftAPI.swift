//
//  SwiftAPI.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ShiftAPI {
    static let shared = ShiftAPI()
    private init() {}
    
    func getShiftList(comletion:@escaping (_ shifts: [String : [Shift]])->Void){
        //if off line get from db
        
        //if on line get from server
        ShiftClient.shared.shiftGet(comletion:{
         shifts in
            comletion(self.formatShiftsListToTableDataSource(shifts: shifts))
        })
        
        //sychronize
    }
    
    func endShift(shift : Shift, comletion:@escaping ()->Void) {
        //store to db
        //sychronize
        ShiftClient.shared.shiftPost(shift: shift, type: .end, comletion: comletion)
        print("End Shift: \(shift)")
    }
    
    func startShift(shift : Shift, comletion:@escaping ()->Void) {
        //store to db
        //sychronize
        ShiftClient.shared.shiftPost(shift: shift, type: .start, comletion: comletion)
        print("start Shift: \(shift)")
    }
    
    func getPic(url: String, comletion:@escaping (_ image: UIImage?)->Void) {
        ShiftClient.shared.picDownload(url: url) {
            image in
            comletion(image)
        }
    }
    
    func sychronizeBetweenDBandServer() {
        //get list from db
        //get list from server
        //compare difference
        //store to db
        //update server
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



