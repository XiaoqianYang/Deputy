//
//  File.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class Shift {
    var id : Int?
    var startTime : Date?
    var endTime : Date?
    var startLocation : CLLocationCoordinate2D?
    var endLocation : CLLocationCoordinate2D?
    var icon : String?
    
    func configShift(id: Int?,startTime: String, endTime: String?, startLatitude: String, startLongitude: String, endLatitude: String?, endLongitude: String?, icon: String?) {
        self.id = id
        self.startTime = Date.DateFrom8601String(string: startTime)
        
        if let et = endTime {
            self.endTime = Date.DateFrom8601String(string: et)
        }
        self.startLocation = CLLocationCoordinate2DMake(Double(startLatitude)!, Double(startLongitude)!)
        
        if let elong = endLongitude, let elat = endLatitude {
            self.endLocation = CLLocationCoordinate2DMake(Double(elat)!, Double(elong)!)
        }
        
        if let ic = icon {
            self.icon = ic
        }
    }
    
}

extension Shift {
    
    func getStartShiftDic() -> NSMutableDictionary? {
        if startTime == nil || startLocation == nil {
            return nil
        }
        else {
            let shiftString = NSMutableDictionary()
            shiftString.setValue(Date.DateTo8601String(date: startTime!), forKey: "time")
            shiftString.setValue(String(format:"%f", (startLocation?.latitude)!), forKey: "latitude")
            shiftString.setValue(String(format:"%f", (startLocation?.longitude)!), forKey: "longitude")
            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
    
    func getEndShiftDic() -> NSMutableDictionary? {
        if endTime == nil || endLocation == nil {
            return nil
        }
        else {
            let shiftString = NSMutableDictionary()
            shiftString.setValue(Date.DateTo8601String(date: endTime!), forKey: "time")
            shiftString.setValue(String(format:"%f", (endLocation?.latitude)!), forKey: "latitude")
            shiftString.setValue(String(format:"%f", (endLocation?.longitude)!), forKey: "longitude")
            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
}
