//
//  ShiftInProgress.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import UIKit
import MapKit

protocol HandleLocationSearch: class {
    func selectPlace(_ placemark:MKPlacemark)
}
class InProgressShiftViewController: UIViewController {
    var shift : Shift!
    
    @IBOutlet var starteTimeLabel: UILabel!
    @IBOutlet var startPlaceLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var endPlaceLabel: UILabel!
    @IBOutlet var endTimeInput: UILabel!
    
    @IBOutlet var endPlaceInput: UILabel!

    let locationManager = CLLocationManager()

    func configureView() {
        starteTimeLabel.text = "Started at : \(shift.startTime!)"
        startPlaceLabel.setPlaceForLabel(coordinate: self.shift.startLocation)
        
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(tapEndTime(_:)))
        endTimeInput.addGestureRecognizer(tapTime)

        let tapPlace = UITapGestureRecognizer(target: self, action: #selector(tapEndPlace(_:)))
        endPlaceInput.addGestureRecognizer(tapPlace)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
    
    @IBAction func endShiftPressed(_ sender: Any) {
    }
    
    func tapEndTime(_ gestureRecognizer: UITapGestureRecognizer) {
        var currentDate = Date()
        
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show("DatePickerDialog", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .dateAndTime) { (date) in
            if let dt = date {
                self.endTimeInput.text = "\(Date.MyDateFromUTCDate(date: dt))"
            }
        }
    }

    func tapEndPlace(_ gestureRecognizer: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationSearchMap") as! LocationSearchMap
        nextViewController.handleLocationSearchDelegate = self
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }

}

extension InProgressShiftViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.endPlaceInput.setPlaceForLabel(coordinate: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension InProgressShiftViewController: HandleLocationSearch {
    
    func selectPlace(_ placemark: MKPlacemark){
        let address = placemark.addressDictionary!["FormattedAddressLines"] as! [String]
        self.endPlaceInput.text = address.joined(separator: ",")
    }
    
}


extension UILabel {
    func setPlaceForLabel(coordinate: CLLocationCoordinate2D) {
        
        let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geoCode = CLGeocoder.init()
        
        geoCode.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            if error != nil {
                self.text = "Place not found"
                return
            }

            if let placeMark = placemarks?[0] {
                
                let address = placeMark.addressDictionary!["FormattedAddressLines"] as! [String]
                self.text = address.joined(separator: ",")
                return
            }
            else {
                self.text = "Place not found"
                return
            }
            
            
        })
    }
    
}
