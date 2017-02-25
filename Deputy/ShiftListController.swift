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
    var shifts = [String : [Shift]]()

    @IBOutlet var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.tableView.reloadData()
            }
        })
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
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
