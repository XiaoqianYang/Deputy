//
//  DeputyTests.swift
//  DeputyTests
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import Deputy

class ShiftDataManagerTests: XCTestCase {
    let coreDataManager = CoreDataManager.shared
    let shiftDataManager = ShiftDataManager.shared
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testaddEmptyShiftToDB() {
        //empty shift should not added to DB
        var beforeadd = 0
        var afteradd = 0

        //get records count before add
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            
            beforeadd = records.count
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

        //add empty shift
        let shift = Shift()
        shiftDataManager.addShiftToDB(shift: shift)
        
        //get records count after add
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            
            afteradd = records.count
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
        assert(beforeadd == afteradd)
    }
    
    
    func testaddGoodShiftToDB() {
        //add good shift
        let shift = Shift(id: 10000, startTime: Date.DateTo8601String(date: Date())!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        shiftDataManager.addShiftToDB(shift: shift)
        
        //get record after add
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        fetchRequest.predicate = NSPredicate(format: "id = %d", 10000)
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            //assert same record
            let date = records[0].startTime as! Date
            XCTAssert(date == shift.startTime)
            
            for item in records {
                coreDataManager.managedObjectContext.delete(item)
            }
            
            try? coreDataManager.managedObjectContext.save()
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
        
    }
    
    func testUpdateShiftDataWithShift() {
        //add shift
        let shift = Shift(id: 10001, startTime: Date.DateTo8601String(date: Date())!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        shiftDataManager.addShiftToDB(shift: shift)
        
        shift.endTime = Date()
        shift.endLocation = CLLocationCoordinate2DMake(0.000000, 0.000000)
        shiftDataManager.updateShiftDataWithShift(shift: shift)
        
        //get record after add
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShiftData")
        fetchRequest.predicate = NSPredicate(format: "id = %d", 10001)
        do {
            let records = try coreDataManager.managedObjectContext.fetch(fetchRequest) as! [ShiftData]
            //assert same record
            let date = records[0].endTime as! Date
            XCTAssert(date == shift.endTime)
            XCTAssert(records[0].endLatitude == shift.endLocation?.latitude)
            XCTAssert(records[0].endLongitude == shift.endLocation?.longitude)
            
            for item in records {
                coreDataManager.managedObjectContext.delete(item)
            }
            
            try? coreDataManager.managedObjectContext.save()
            
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }

    func testGetShiftDataFromDBByID(){
        let shift = Shift(id: 10003, startTime: Date.DateTo8601String(date: Date())!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        shiftDataManager.addShiftToDB(shift: shift)
        
        let data = shiftDataManager.getShiftDataFromDB(byId: 10003)
        let date = data?.startTime as! Date
        XCTAssert(date == shift.startTime)
        
        coreDataManager.managedObjectContext.delete(data!)
        
        try? coreDataManager.managedObjectContext.save()
            
    }
    
    func testGetShiftsFromDB() {
        let shift = Shift(id: 10004, startTime: Date.DateTo8601String(date: Date())!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        shiftDataManager.addShiftToDB(shift: shift)
        
        let shifts = shiftDataManager.getShiftsFromDB()
        let date = shifts![0].startTime! 
        XCTAssert(shifts![0].id == shift.id)
        XCTAssert(date == shift.startTime)
        
        let toDelete = shiftDataManager.getShiftDataFromDB(byId: 10004)
        
        coreDataManager.managedObjectContext.delete(toDelete!)
        
        try? coreDataManager.managedObjectContext.save()
        
    }
    
    func testSychronizeShiftsToDB() {
        let shift1 = Shift(id: 10005, startTime: Date.DateTo8601String(date: Date())!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        let shift2 = Shift(id: 10006, startTime: Date.DateTo8601String(date: Date().addingTimeInterval(2))!, endTime: nil, startLatitude: "0.00000", startLongitude: "0.00000", endLatitude:nil , endLongitude:nil , icon:nil )
        shiftDataManager.sychronizeShiftsToDB(shifts: [shift1,shift2])
        
        let shifts = shiftDataManager.getShiftsFromDB()
        XCTAssert(shifts![0].id == shift2.id,"id:\(shifts![0].id), id:\(shift2.id)")
        XCTAssert(shifts![0].startTime! == shift2.startTime!, "date0:\(shifts![0].startTime!), date2:\(shift2.startTime!)")
        XCTAssert(shifts![1].id == shift1.id, "id:\(shifts![1].id), id:\(shift1.id)")
        XCTAssert(shifts![1].startTime! == shift1.startTime!, "date1:\(shifts![1].startTime!), date1:\(shift1.startTime!)")
        
        let toDelete = shiftDataManager.getShiftDataFromDB(byId: 10005)
        
        coreDataManager.managedObjectContext.delete(toDelete!)
        
        let toDelete2 = shiftDataManager.getShiftDataFromDB(byId: 10006)
        
        coreDataManager.managedObjectContext.delete(toDelete2!)

        try? coreDataManager.managedObjectContext.save()
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
