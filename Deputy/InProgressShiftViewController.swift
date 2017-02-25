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
    @IBOutlet var endTimeInput: UILabel!
    
    @IBOutlet var endPlaceInput: UILabel!

    @IBOutlet var endShiftBtn: UIButton!
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    let locationManager = CLLocationManager()

    func configureView() {
        starteTimeLabel.text = Date.MyDateFromDate(date: shift.startTime)
        startPlaceLabel.setPlaceForLabel(coordinate: self.shift.startLocation)
        
        endTimeInput.text = Date.MyDateFromDate(date: Date())
        self.shift.endTime = Date()
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(tapEndTime(_:)))
        endTimeInput.addGestureRecognizer(tapTime)

        let tapPlace = UITapGestureRecognizer(target: self, action: #selector(tapEndPlace(_:)))
        endPlaceInput.addGestureRecognizer(tapPlace)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        endTimeInput.layer.borderColor = UIColor.lightGray.cgColor
        endTimeInput.layer.borderWidth = 0.5
        endTimeInput.layer.cornerRadius = 5

        endPlaceInput.layer.borderColor = UIColor.lightGray.cgColor
        endPlaceInput.layer.borderWidth = 0.5
        endPlaceInput.layer.cornerRadius = 5
        endShiftBtn.layer.cornerRadius = 5

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
        if (self.shift.endTime == nil || self.shift.endLocation == nil) {
            let alert = UIAlertController(title: "Please input end time", message: "", preferredStyle: .alert)
            
            if self.shift.endTime == nil {
                alert.title = "Please input end time"
            }
            else {
                alert.title = "please input end location"
            }
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler:nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: {
                return
            })
        }
        else {
            ShiftAPI.shared.endShift(shift: self.shift, comletion: {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            })
            self.indicatorView.startAnimating()
        }
    }
    
    func tapEndTime(_ gestureRecognizer: UITapGestureRecognizer) {
        var currentDate : Date
        if (self.shift.endTime != nil) {
            currentDate = self.shift.endTime!
        }
        else {
            currentDate = Date()
        }
        
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        DatePickerDialog().show("Selet End Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .dateAndTime) { (date) in
            if let dt = date {
                self.endTimeInput.text = "\(Date.MyDateFromDate(date: dt))"
                self.shift.endTime = dt
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
        self.shift.endLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension InProgressShiftViewController: HandleLocationSearch {
    
    func selectPlace(_ placemark: MKPlacemark){
        let address = placemark.addressDictionary!["FormattedAddressLines"] as! [String]
        self.endPlaceInput.text = address.joined(separator: ",")
        self.shift.endLocation = placemark.coordinate
    }
    
}


extension UILabel {
    func setPlaceForLabel(coordinate: CLLocationCoordinate2D?) {
        if coordinate == nil {
            return
        }
        let location = CLLocation.init(latitude: coordinate!.latitude, longitude: coordinate!.longitude)
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
