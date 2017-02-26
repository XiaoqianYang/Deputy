//
//  ShiftClient.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 24/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

enum UpdateShiftType {
    case start
    case end
}

class ShiftClient {
    static let shared = ShiftClient()
    var config : URLSessionConfiguration
    var session : URLSession
    var urlString : String
    
    private init() {
        let authString = "Deputy \(Constants.CURRENT_USER_TOKEN)"
        config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization" : authString]
        session = URLSession(configuration: config)
        
        urlString = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    }

    func shiftGet(comletion:@escaping (_ shifts: [Shift]?)->Void){
        let url = URL(string: "\(urlString)/shifts")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {
            ( data, response, error) in
            if data != nil {
                var json: [Any]?
                do {
                    json = try JSONSerialization.jsonObject(with: data!) as? [Any]
                    if(json == nil) {
                        comletion(nil)
                    }
                    else {
                        comletion(self.jsonToShifts(json: json!))
                    }
                }
                catch {
                    print(error)
                    comletion(nil)
                }
             }
            else {
                comletion(nil)
            }

        }

        task.resume()

    }
    
    func shiftPost(shift: Shift, type: UpdateShiftType, comletion:@escaping ()->Void) {
        var url : URL
        var dic : NSMutableDictionary
        if type == .start {
            url = URL(string: "\(urlString)/shift/start")!
            dic = getStartShiftDic(byShift: shift)!
        }
        else {
            url = URL(string: "\(urlString)/shift/end")!
            dic = getEndShiftDic(byShift: shift)!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) {
            ( data, response, error) in
            if let e = error {
                print("POST Error: \(e)")
            }
            else {
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString ?? "")
                comletion()
            }
            
        }
        
        task.resume()
    }
    
    func picDownload(url: String, comletion:@escaping (_ image: UIImage?)->Void){
        let url = URL(string: url)
        
        let task = session.dataTask(with: url!) {
            ( data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
                comletion(nil)
            } else {
                if let res = response as? HTTPURLResponse {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        comletion(image!)
                    } else {
                        print("Couldn't get image: Image is nil")
                        comletion(nil)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                    comletion(nil)
                }
            }
            
        }
        
        task.resume()
        
    }

    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    private func jsonToShifts(json:[Any]) -> [Shift] {
        var shifts = [Shift]()
        for(_, item) in (json.enumerated()) {
            let it = item as! [String: Any]
            
            guard let id = it["id"] as? Int,
                let start = it["start"] as? String,
                let startLatitude = it["startLatitude"] as? String,
                let startLongitude = it["startLongitude"] as? String
                else {
                    continue
                }
            let end = it["end"] as? String
            let endLatitude = it["endLatitude"] as? String
            let endLongitude = it["endLongitude"] as? String
            let icon = it["image"] as? String
            
            let shift = Shift(id: id, startTime: start, endTime: end, startLatitude: startLatitude, startLongitude: startLongitude, endLatitude: endLatitude, endLongitude: endLongitude, icon: icon)
            shifts.append(shift)
        }
        
        //TODO Sort With StartTime
        return shifts
    }

    
    private func getStartShiftDic(byShift shift:Shift) -> NSMutableDictionary? {
        if shift.startTime == nil || shift.startLocation == nil {
            return nil
        }
        else {
            let shiftString = NSMutableDictionary()
            shiftString.setValue(Date.DateTo8601String(date: shift.startTime!), forKey: "time")
            shiftString.setValue(String(format:"%f", (shift.startLocation?.latitude)!), forKey: "latitude")
            shiftString.setValue(String(format:"%f", (shift.startLocation?.longitude)!), forKey: "longitude")
            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
    
    private func getEndShiftDic(byShift shift:Shift) -> NSMutableDictionary? {
        if shift.endTime == nil || shift.endLocation == nil {
            return nil
        }
        else {
            let shiftString = NSMutableDictionary()
            shiftString.setValue(Date.DateTo8601String(date: shift.endTime!), forKey: "time")
            shiftString.setValue(String(format:"%f", (shift.endLocation?.latitude)!), forKey: "latitude")
            shiftString.setValue(String(format:"%f", (shift.endLocation?.longitude)!), forKey: "longitude")
            
            print("String\n\(shiftString)")
            return shiftString
        }
    }
}

