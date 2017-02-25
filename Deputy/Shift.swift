//
//  File.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import CoreLocation

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
    func getStartShiftJSON() -> Data? {
        if startTime == nil || startLocation == nil {
            return nil
        }
        else {
            let jsonData: [String: String] = [
            //"time": Date.DateTo8601String(date: startTime!)!,
            "time": "2017-01-17T06:35:57+00:00",
            "latitude": String(format:"%.5f",(startLocation?.latitude)!),
            "longitude": String(format:"%.5f",(startLocation?.longitude)!)
            ]
            
            print("JsonData\n\(jsonData)")
            return try? JSONSerialization.data(withJSONObject: jsonData)
        }
    }
    
    func getStartShiftString() -> String? {
        if startTime == nil || startLocation == nil {
            return nil
        }
        else {
            let shiftString =
                "{\"time\":\"2017-02-25T06:35:57+00:00\",\"latitude\":\"0.00000\",\"longitude\":\"0.00000\"}"
                //"{\"time\":\"2017-02-25T06:35:57+00:00\",\"latitude\":\"\(String(format:"%.5f",(startLocation?.latitude)!))\",\"longitude\":\"\(String(format:"%.5f",(startLocation?.longitude)!))\"}"

            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
    func getStartShiftDic() -> NSMutableDictionary? {
        if startTime == nil || startLocation == nil {
            return nil
        }
        else {
            let shiftString = NSMutableDictionary()
            shiftString.setValue("2017-02-25T06:35:57+00:00", forKey: "time")
            shiftString.setValue("-33.93677", forKey: "latitude")
            shiftString.setValue("151.16748", forKey: "longitude")
            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
}
