//
//  ShiftList.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ShiftListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    @IBOutlet var segment: UISegmentedControl!

    @IBOutlet var mapView: MKMapView!

    var shifts = [String : [Shift]]()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Shifts"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        startButton.layer.cornerRadius = 4
        
        self.mapView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShiftAPI.shared.getShiftList(comletion: {
            shifts in
            self.shifts = shifts
            DispatchQueue.main.async {
                if (Array(self.shifts.keys).contains(Constants.SHIFT_SECTION_NAME_INPROGRESS)) {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
                else {
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor(displayP3Red: 149/255.0, green: 205/255.0, blue: 18/255.0, alpha: 1)
                }
                
                self.tableView.reloadData()
                self.indicatorView.stopAnimating()
            }
        })
        self.indicatorView.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

// MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return shifts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(shifts.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(shifts.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!ShiftCell
        let shift = Array(shifts.values)[indexPath.section][indexPath.row]
        cell.configCell(shift: shift)
        return cell
    }

// MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if Array(shifts.keys)[indexPath.section] == Constants.SHIFT_SECTION_NAME_INPROGRESS {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InProgress") as! InProgressShiftViewController
            nextViewController.shift = Array(shifts.values)[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
        else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "FinishedShift") as! FinishedShiftController
            nextViewController.shift = Array(shifts.values)[indexPath.section][indexPath.row]
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        if self.segment.selectedSegmentIndex == 1 {
            mapView.isHidden = false
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
            var allShifts = [Shift]()
            if let inprogress = shifts[Constants.SHIFT_SECTION_NAME_INPROGRESS] {
                allShifts.append(contentsOf: inprogress)
            }
            if let finished = shifts[Constants.SHIFT_SECTION_NAME_FINISHED] {
                allShifts.append(contentsOf: finished)
            }
            for shift in allShifts {
                mapView.addShiftAnnotation(type: .start, coordinate: shift.startLocation!, time: shift.startTime!)
                
                if shift.endTime != nil {
                    mapView.addShiftAnnotation(type: .end, coordinate: shift.endLocation!, time: shift.endTime!)
                }
            }

            tableView.isHidden = true
            tableView.delegate = nil
            tableView.dataSource = nil
        }
        else {
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            
            mapView.isHidden = true
            mapView.removeAnnotations(mapView.annotations)
            locationManager.delegate = nil
            locationManager.stopUpdatingLocation()

        }
    }

}

extension ShiftListController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
}

