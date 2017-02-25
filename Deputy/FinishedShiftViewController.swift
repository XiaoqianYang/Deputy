//
//  DetailViewController.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import UIKit
import MapKit

class FinishedShiftController: UIViewController {
    var shift : Shift!
    
    @IBOutlet var mapView: MKMapView!

    func configureView() {        
        // Config mapview
        let distance = CLLocation.init(latitude: (shift.startLocation?.latitude)!, longitude: (shift.startLocation?.longitude)!).distance(from: CLLocation.init(latitude: (shift.endLocation?.latitude)!, longitude: (shift.endLocation?.longitude)!))
        var region = MKCoordinateRegionMakeWithDistance(getCenterBetweenTwoCoordinate(point1: shift.startLocation!, point2: shift.endLocation!), distance*2, distance*2)
        region = mapView.regionThatFits(region)
        if (!(region.span.latitudeDelta).isNaN && !(region.span.longitudeDelta).isNaN) {
            mapView.setRegion(region, animated: true)
        }
        
        self.mapView.addShiftAnnotation(type: .start, coordinate: self.shift.startLocation!, time: self.shift.startTime!)
        self.mapView.addShiftAnnotation(type: .end, coordinate: self.shift.endLocation!, time: self.shift.endTime!)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func degreesToRadians(degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / M_PI }
    
    func getCenterBetweenTwoCoordinate(point1 : CLLocationCoordinate2D, point2 : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
    
        let lat1 = degreesToRadians(degrees: point1.latitude)
        let lon1 = degreesToRadians(degrees: point1.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.latitude)
        let lon2 = degreesToRadians(degrees: point2.longitude)
        
        let dLon = lon2 - lon1
        
        let x = cos(lat2) * cos(dLon);
        let y = cos(lat2) * sin(dLon);
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) );
        let lon3 = lon1 + atan2(y, cos(lat1) + x);
        
        return CLLocationCoordinate2DMake(lat3 * 180 / M_PI, lon3 * 180 / M_PI);

    
    }
}

extension MKMapView {
    func addShiftAnnotation(type: ShiftAnnotationType, coordinate: CLLocationCoordinate2D, time: Date) {
        
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
                let annotation = ShiftAnnotation(coordinate: coordinate, title: stringType, subtitle: Date.MyDateFromDate(date: time))
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
                        title = "Started at: \(Date.MyDateFromDate(date: time))"
                    case .end:
                        title = "Ended at: \(Date.MyDateFromDate(date: time))"
                    }
                }
                
                let address = placeMark.addressDictionary!["FormattedAddressLines"] as! [String]
                let subtitle = address.joined(separator: ",")
                
                self.addAnnotation(ShiftAnnotation(coordinate: coordinate, title: title, subtitle: "\(subtitle)"))
            }
            else {
                self.addAnnotation(ShiftAnnotation(coordinate: coordinate, title: stringType, subtitle: Date.MyDateFromDate(date: time)))
            }
            
            
        })
    }
    
}


