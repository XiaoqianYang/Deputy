//
//  StartShiftViewController.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 24/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import UIKit
import MapKit

class StartShiftViewController: UIViewController {
    var shift = Shift()
    
    @IBOutlet var startTimeInput: UILabel!
    @IBOutlet var startPlaceInput: UILabel!
    @IBOutlet var startShiftBtn: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    func configureView() {
        self.title = "Start Shift"
        startTimeInput.text = Date.MyDateFromDate(date: Date())
        self.shift.startTime = Date()
        let tapTime = UITapGestureRecognizer(target: self, action: #selector(tapStartTime(_:)))
        startTimeInput.addGestureRecognizer(tapTime)
        
        let tapPlace = UITapGestureRecognizer(target: self, action: #selector(tapStartPlace(_:)))
        startPlaceInput.addGestureRecognizer(tapPlace)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        startTimeInput.layer.borderColor = UIColor.lightGray.cgColor
        startTimeInput.layer.borderWidth = 0.5
        startTimeInput.layer.cornerRadius = 5
        
        startPlaceInput.layer.borderColor = UIColor.lightGray.cgColor
        startPlaceInput.layer.borderWidth = 0.5
        startPlaceInput.layer.cornerRadius = 5
        startShiftBtn.layer.cornerRadius = 5
        
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
    
    @IBAction func startShiftPressed(_ sender: Any) {
        if (self.shift.startTime == nil || self.shift.startLocation == nil) {
            let alert = UIAlertController(title: "Please input end time", message: "", preferredStyle: .alert)
            
            if self.shift.startTime == nil {
                alert.title = "Please input start time"
            }
            else {
                alert.title = "please input start location"
            }
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler:nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: {
                return
            })
        }
        else {
            ShiftAPI.shared.startShift(shift: self.shift, comletion: {
                DispatchQueue.main.async {
                    self.indicatorView.stopAnimating()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            
            })

            self.indicatorView.startAnimating()
        }
    }
    
    func tapStartTime(_ gestureRecognizer: UITapGestureRecognizer) {
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
        
        DatePickerDialog().show("Select Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: threeMonthAgo, maximumDate: currentDate, datePickerMode: .dateAndTime) { (date) in
            if let dt = date {
                self.startTimeInput.text = "\(Date.MyDateFromDate(date: dt))"
                self.shift.startTime = dt
            }
        }
    }
    
    func tapStartPlace(_ gestureRecognizer: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LocationSearchMap") as! LocationSearchMap
        nextViewController.handleLocationSearchDelegate = self
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
}

extension StartShiftViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.startPlaceInput.setPlaceForLabel(coordinate: location.coordinate)
        self.shift.startLocation = location.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

extension StartShiftViewController: HandleLocationSearch {
    
    func selectPlace(_ placemark: MKPlacemark){
        let address = placemark.addressDictionary!["FormattedAddressLines"] as! [String]
        self.startPlaceInput.text = address.joined(separator: ",")
        self.shift.startLocation = placemark.coordinate
    }
    
}
