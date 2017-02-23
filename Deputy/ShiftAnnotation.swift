//
//  ShiftAnnotation.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import MapKit

enum ShiftAnnotationType {
    case start
    case end
}

class ShiftAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle : String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}

extension MKMapView {
    func addShiftAnnotation(type: ShiftAnnotationType, coordinate: CLLocationCoordinate2D, time: String) {
        let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geoCode = CLGeocoder.init()
        geoCode.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            var stringType : String
            switch type {
            case .start:
                stringType = "start"
            case .end:
                stringType = "end"
            }
            
            if error != nil {
                let annotation = ShiftAnnotation(coordinate: coordinate, title: stringType, subtitle: time)
                self.addAnnotation(annotation)
                print(error?.localizedDescription)
                return
            }
            // Place details
            if let placeMark = placemarks?[0] {
                var title : String?
                // Location name
                if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                    switch type {
                    case .start:
                        title = "Started at: \(time)"
                    case .end:
                        title = "Ended at: \(time)"
                    }
                }
                
                let address = placeMark.addressDictionary!["FormattedAddressLines"] as! [String]
                let subtitle = address.joined(separator: ",")
                
                self.addAnnotation(ShiftAnnotation(coordinate: coordinate, title: title, subtitle: "\(subtitle)"))
            }
            else {
                self.addAnnotation(ShiftAnnotation(coordinate: coordinate, title: stringType, subtitle: time))
            }
            
            
        })
    }
    
}
