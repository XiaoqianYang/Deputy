//
//  ShiftClient.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 24/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation

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

    func getShiftListFromServer(comletion:@escaping (_ shifts: [Shift])->Void){
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
                        comletion([])
                    }
                    else {
                        comletion(self.jsonToShifts(json: json!))
                    }
                }
                catch {
                    print(error)
                    comletion([])
                }
             }
            else {
                comletion([])
            }

        }

        task.resume()

    }
    
    func startShiftOnServer(shift: Shift) {
        
        let url = URL(string: "\(urlString)/shift/end")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let dic = shift.getStartShiftDic()
        request.httpBody = try? JSONSerialization.data(withJSONObject: dic!)
        let json = try? JSONSerialization.jsonObject(with: request.httpBody!)
        print(json ?? "")
//        let data = shift.getStartShiftJSON()
//        print("JSON\n\(data)")
//        let jsonString = String(data: data!, encoding: .utf8)
//        print("JsonString \(jsonString)")
//        request.httpBody = data
//        let stringData = shift.getStartShiftString()
//        request.httpBody = stringData!.data(using: .utf8, allowLossyConversion: true)
        
        let task = session.dataTask(with: request) {
            ( data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(dataString ?? "No response data")
                }
            }
            
        }
        
        task.resume()
        
    }
    
    func jsonToShifts(json:[Any]) -> [Shift] {
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
            let icon = it["icon"] as? String
            
            let shift = Shift()
            shift.configShift(id: id, startTime: start, endTime: end, startLatitude: startLatitude, startLongitude: startLongitude, endLatitude: endLatitude, endLongitude: endLongitude, icon: icon)
            shifts.append(shift)
        }
        return shifts
    }

    
}
