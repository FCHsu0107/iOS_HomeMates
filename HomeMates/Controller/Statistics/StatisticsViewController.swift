//
//  StatisticsViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FSCalendar

class StatisticsViewController: HMBaseViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    

}

extension StatisticsViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}


