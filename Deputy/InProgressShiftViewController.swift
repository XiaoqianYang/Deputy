//
//  ShiftInProgress.swift
//  Deputy
//
//  Created by Xiaoqian Yang on 22/2/17.
//  Copyright © 2017 XiaoqianYang. All rights reserved.
//

import UIKit

class InProgressShiftViewController: UIViewController {
    var shift : Shift!
    
    func configureView() {
        // Update the user interface for the detail item.
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
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
}
