//
//  ShiftDataManager.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 25/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import CoreData

class ShiftDataManager {
    static let shared = ShiftDataManager()
    lazy var coreDataManager = CoreDataManager.shared
    
    func getShiftsFromDB() -> [Shift]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var shifts = [Shift]()
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            
            for record in records {
                let shift = Shift(fromShiftData: record)
                shifts.append(shift)
            }
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

        return shifts
    }
    
    func sychronizeShiftsToDB(shifts: [Shift]) {
        //TODO Sort shifts with startTime
        let shiftDatas = getShiftDataFromDB()
        
        if shiftDatas != nil && shiftDatas!.count > 0 {
            for shift in shifts {
                var shouldAdd = true
                for shiftData in shiftDatas! {
                    if (shift.id == Int(shiftData.id)) {
                        //update
                        shift.shiftData = shiftData
                        updateShiftDataWithShift(shift: shift)
                        shouldAdd = false
                        break
                    }
                }
                
                if shouldAdd {
                    //Add current shift
                    addShiftToDB(shift: shift)
                }
            }
        }
        else {
            //Add all to db
            for shift in shifts {
                addShiftToDB(shift: shift)
            }
        }
    }
    
    private init() {}
    
    private func getShiftDataFromDB() -> [ShiftData]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "startTime", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var shifts = [ShiftData]()
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            
            shifts.append(contentsOf: records)
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        return shifts
    }
    
    private func getShiftDataFromDB(byId id: Int) -> ShiftData? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            
            if records.count > 0 {
                return records[0] as ShiftData
            }
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        return nil
    }
    
    private func updateShiftDataWithShift(shift: Shift) {
        var shiftData = shift.shiftData
        if shiftData == nil {
            shiftData = getShiftDataFromDB(byId: shift.id!)
        }
        
        if shiftData == nil {
            return
        }
        
        //nothing changed, do not need update
        if  shift.endTime == nil || (shiftData!.endTime != nil && shift.endTime == shiftData!.endTime as? Date){
            return
        }
        
        shiftData!.setValue(shift.id, forKey: "id")
        shiftData!.setValue(shift.startTime! as NSDate, forKey: "startTime")
        shiftData!.setValue(shift.startLocation!.latitude, forKey: "startLatitude")
        shiftData!.setValue(shift.startLocation!.longitude, forKey: "startLongitude")
        
        if shift.endTime != nil {
            shiftData!.setValue(shift.endTime! as NSDate, forKey: "endTime")
        }
        
        if shift.endLocation != nil {
            shiftData!.setValue(shift.endLocation!.latitude, forKey: "endLatitude")
            shiftData!.setValue(shift.endLocation!.longitude, forKey: "endLongitude")
        }
        
        if shift.icon != nil {
            shiftData!.setValue(shift.icon, forKey: "icon")
        }
        
        try? coreDataManager.managedObjectContext.save()
    }
    
    private func addShiftToDB(shift: Shift) {
        let shiftData = NSEntityDescription.insertNewObject(forEntityName: "ShiftData", into: coreDataManager.managedObjectContext)
        shiftData.setValue(shift.id, forKey: "id")
        shiftData.setValue(shift.startTime! as NSDate, forKey: "startTime")
        shiftData.setValue(shift.startLocation!.latitude, forKey: "startLatitude")
        shiftData.setValue(shift.startLocation!.longitude, forKey: "startLongitude")
        
        if shift.endTime != nil {
            shiftData.setValue(shift.endTime! as NSDate, forKey: "endTime")
        }
        
        if shift.endLocation != nil {
            shiftData.setValue(shift.endLocation!.latitude, forKey: "endLatitude")
            shiftData.setValue(shift.endLocation!.longitude, forKey: "endLongitude")
        }
        
        if shift.icon != nil {
            shiftData.setValue(shift.icon, forKey: "icon")
        }
        
        try? coreDataManager.managedObjectContext.save()
    }
    
}

