//
//  StatisticsViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FSCalendar

class StatisticsViewController: HMBaseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBtn: UIBarButtonItem!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
//        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        
        // For UITest
//        self.calendar.accessibilityIdentifier = "calendar"
    }
    deinit {
        print("\(#function)")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    
    
    @IBAction func weeklyBtnClicked(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
//            self.navigationBtn.title = "Month"
            
        } else {
            self.calendar.setScope(.month, animated: true)
//            self.navigationBtn.title = "Week"
        }
    }
    
}

extension StatisticsViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}


