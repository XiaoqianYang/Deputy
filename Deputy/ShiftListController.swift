//
//  ShiftList.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import Foundation
import UIKit

class ShiftListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var startButton: UIButton!
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    var shifts = [String : [Shift]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Shifts"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        startButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ShiftAPI.shared.getShiftList(comletion: {
            shifts in
            self.shifts = shifts
            DispatchQueue.main.async {
                if (self.shifts[Constants.SHIFT_SECTION_NAME_INPROGRESS]?.count)! > 0 {
                    self.startButton.isEnabled = false
                    self.startButton.backgroundColor = UIColor.lightGray
                }
                else {
                    self.startButton.isEnabled = true
                    self.startButton.backgroundColor = UIColor(displayP3Red: 148/255.0, green: 205/255.0, blue: 18/255.0, alpha: 1)
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
        
        if indexPath.section == 0 {
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
}
