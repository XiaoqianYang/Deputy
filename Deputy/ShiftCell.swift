//
//  ShiftCell.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import UIKit

class ShiftCell: UITableViewCell {
    
    @IBOutlet var startedLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var endedLabel: UILabel!
    
    func configCell(shift : Shift) {
        
        self.startedLabel.text = "Started at: \(Date.MyDateFromDate(date: shift.startTime))"
        if (shift.endTime != nil) {
            self.endedLabel.text = "Ended at: \(Date.MyDateFromDate(date: shift.endTime))"
        }
        else {
            self.endedLabel.text = "InProgress"
        }
        self.iconView.image = UIImage.init(named: "icon")
        
        if shift.icon == nil {
            return
        }
        else {
            ShiftAPI.shared.getPic(url: shift.icon!, comletion: {image in
                if image == nil {
                    return
                }
                DispatchQueue.main.async {
                    self.iconView.image = image
                }
            })
        }
    }
}
