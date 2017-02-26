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
    var shiftData : ShiftData?
    
    init() {}
    init(id: Int?,startTime: String, endTime: String?, startLatitude: String, startLongitude: String, endLatitude: String?, endLongitude: String?, icon: String?) {
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

    init(fromShiftData shiftData:ShiftData) {
        self.id = Int(shiftData.id)
        self.startTime = shiftData.startTime as Date?
        
        
        self.endTime = shiftData.endTime as Date?
        
        self.startLocation = CLLocationCoordinate2DMake(shiftData.startLatitude, shiftData.startLongitude)
        
        self.endLocation = CLLocationCoordinate2DMake(shiftData.endLatitude, shiftData.endLongitude)
        
        self.icon = shiftData.icon
        
        self.shiftData = shiftData
    
    }
}
