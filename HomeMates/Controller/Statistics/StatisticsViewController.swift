//
//  StatisticsViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import JTAppleCalendar

class StatisticsViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
        {
        didSet {
            calendarView.calendarDelegate = self
            calendarView.calendarDataSource = self
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: String(describing: CalendarCell.self))
        
    }
    

}

extension StatisticsViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let dayCell = cell as? CalendarCell else { return }
        
        //Setup cell text
        dayCell.dayLabel.text = cellState.text
        
        //Setup text color
        if cellState.dateBelongsTo == .thisMonth {
            dayCell.dayLabel.textColor = UIColor.Y4
        } else {
            dayCell.dayLabel.textColor = UIColor.Y2
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
       let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! CalendarCell
        let formatter = DateFormatter()
        if cellState.text == "1" {
            
            formatter.dateFormat = "MMM"
            let month = formatter.string(from: date)
            cell.dayLabel .text = "\(month) \(cellState.text)"
        } else {
            cell.dayLabel .text = cellState.text
        }
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: false)
        return parameters
    }
    
    
}
