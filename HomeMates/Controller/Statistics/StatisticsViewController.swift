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

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.jq_registerCellWithNib(identifier: String(describing: EventCell.self), bundle: nil)
            tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
            tableView.jq_registerCellWithNib(identifier: String(describing: ChartsTableViewCell.self), bundle: nil)
            tableView.jq_registerCellWithNib(identifier: String(describing: TrackerTableViewCell.self), bundle: nil)
        }
    }

    let taskHeaderView = TaskListHeaderView()

    @IBOutlet weak var calendar: FSCalendar! {
        didSet {
            self.calendar.select(Date())
            self.calendar.scope = .week
            self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
            self.calendar.addGestureRecognizer(self.scopeGesture)
        }
    }

    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar,
                                                action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    var datesWithEvent = ["2019/04/03", "2019/04/04",
                          "2019/04/05", "2019/04/06",
                          "2019/04/10", "2019/04/11"]
    
    var datesWithMultipleEvents = ["2019/04/07", "2019/04/08", "2019/04/09", "2019/04/10"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    deinit {
        print("\(#function)")
    }

    @IBAction func weeklyBtnClicked(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }

}

extension StatisticsViewController: FSCalendarDataSource, FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        //        if self.datesWithMultipleEvents.contains(dateString) {
        //            return 3
        //        }
        return 0
    }
    
    //    func calendar(_ calendar: FSCalendar,
    //    appearance: FSCalendarAppearance,
    //    eventDefaultColorsFor date: Date) -> [UIColor]? {
    //        let key = self.dateFormatter.string(from: date)
    //        if self.datesWithMultipleEvents.contains(key) {
    //            return [UIColor.Y3 ?? UIColor.orange, appearance.eventDefaultColor, UIColor.black]
    //        }
    //        return nil
    //    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let taskHeaderTitle = ["過往貢獻度", "任務分佈", "過往記錄"]
        
        switch section {
        case 1, 2, 3:
            let headerView = taskHeaderView.taskTitle(tableView: tableView, titleText: taskHeaderTitle[section - 1])
            return headerView

        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        default:
            return 40
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2, 3: return 1
        case 1: return 3
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCell.self),
                                                     for: indexPath)
            guard let eventCell = cell as? EventCell else { return cell }

            return eventCell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                     for: indexPath)
            guard let contributionCell = cell as? TasksTableViewCell else { return cell}

            contributionCell.showContributionView(member: "哎唷喂啊",
                                                  memberImage: "profile",
                                                  personalTotalPoints: 50,
                                                  persent: 50)
            return contributionCell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChartsTableViewCell.self),
                                                     for: indexPath)
            guard let chartCell = cell as? ChartsTableViewCell else { return cell }
            
            return chartCell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackerTableViewCell.self),
                                                     for: indexPath)
            guard let trackerCell = cell as? TrackerTableViewCell else { return cell }
            return trackerCell
            
        default:
            return UITableViewCell()
        }
    }
}
