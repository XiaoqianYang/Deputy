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
        self.startedLabel.text = "Started at: \(shift.startTime!)"
        self.endedLabel.text = "Ended at: \(shift.endTime!)"
    }
}
