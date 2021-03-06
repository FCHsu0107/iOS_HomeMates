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

    @IBOutlet weak var tableView: UITableView!

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

    var datesWithEvent: [String] = [] {
        didSet {
            self.calendar.reloadData()
        }
    }
    
    let taskHeaderView = TaskListHeaderView()
    
    var taskList: [TaskObject] = []
    
    var dateTaskList: [TaskObject] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var memberInfo: [MemberObject] = []
    
    var memberInfoWithPoint: [MemberWithPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        headerLoader()
        addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.jq_registerCellWithNib(identifier: String(describing: EventCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: PointGoalTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TrackerTableViewCell.self), bundle: nil)
    }
    
    private func headerLoader() {
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.readDoneTask()
        })
        
        tableView.beginHeaderRefreshing()
    }
    
    private func readDoneTask() {

        FIRFirestoreSerivce.shared.readDoneTask { [weak self] (tasks) in
            self?.getDateMark(tasks: tasks)
            let currentDate = DateProvider.shared.getCurrentDate()
            self?.getDateTask(selectedDate: currentDate)
            
            FirestoreGroupManager.shared.readGroupMembers { [weak self] (members) in
                self?.memberInfoWithPoint = []
                for member in members {
                    let object: MemberWithPoint = MemberWithPoint(memberName: member.userName,
                                                                  memberUid: member.userId,
                                                                  memberPicture: member.userPicture,
                                                                  point: 0, goal: member.goal)
                    self?.memberInfoWithPoint.append(object)
                }

                for j in 0 ..< members.count {
                    for i in 0 ..< tasks.count where tasks[i].executorUid == self?.memberInfoWithPoint[j].memberUid {
                        guard let timeStamp = tasks[i].completionTimeStamp else { return }
                        let currentMonth = DateProvider.shared.getCurrentMonth()
                        let tasksMonth = DateProvider.shared.getCurrentMonth(currentTimeStamp: timeStamp)
                        if tasksMonth == currentMonth {
                            self?.memberInfoWithPoint[j].point += tasks[i].taskPoint
                        }
                    }
                }
                
                self?.tableView.reloadData()
                self?.tableView.endHeaderRefreshing()
            }
        }
    }
    
    private func getDateTask(selectedDate: String) {
        dateTaskList = []
        for (index, element) in taskList.enumerated() where element.completionDate == selectedDate {
            dateTaskList.append(taskList[index])
        }
    }
    
    private func getDateMark(tasks: [TaskObject]) {
        datesWithEvent = []
        for task in tasks {
            guard let timeStamp = task.completionTimeStamp else { return }
            let date = DateProvider.shared.getCurrentDate(currentTimeStamp: timeStamp)
            datesWithEvent.append(date)
        }
        taskList = tasks
        for index in 0..<tasks.count {
            taskList[index].completionDate = datesWithEvent[index]
        }
    }

    @IBAction func weeklyBtnClicked(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(refreshNewTask(noti:)),
            name: Notification.Name(NotificationName.taskIsDone.rawValue), object: nil)
    }
    
    @objc func refreshNewTask(noti: Notification) {
        headerLoader()
    }
   
}

extension StatisticsViewController: FSCalendarDataSource, FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDate = self.dateFormatter.string(from: date)
        getDateTask(selectedDate: selectedDate)
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
        //不同月份換資料
    }
    
    //日曆下方的圓點
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let taskHeaderTitle = [" 過往紀錄", "目標達成率"]
        
        switch section {
        case 1, 2:
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
            return 60
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1 : return 1
        case 2: return memberInfoWithPoint.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCell.self),
                                                     for: indexPath)
            guard let eventCell = cell as? EventCell else { return cell }
            eventCell.loadData(tasks: dateTaskList)

            return eventCell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TrackerTableViewCell.self),
                                                     for: indexPath)
            guard let trackerCell = cell as? TrackerTableViewCell else { return cell }
            trackerCell.loadData(tasks: taskList)
            trackerCell.delegate = self
            trackerCell.taskTrackerHandler = { [weak self] (taskName) in
                self?.selectedSpecificTask(taskName: taskName, trackerCell: trackerCell)
            }
            
            return trackerCell

        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PointGoalTableViewCell.self),
                                                     for: indexPath)
            guard let contributionCell = cell as? PointGoalTableViewCell else { return cell}
            
            contributionCell.showContributionView(memberInfo: memberInfoWithPoint[indexPath.row])
            
            return contributionCell
        default:
            return UITableViewCell()
        }
    }
    
    private func selectedSpecificTask(taskName: String, trackerCell: TrackerTableViewCell) {
        var taskDates: [String] = []
        var userNames: [String] = []
        for task in taskList {
            if taskName == task.taskName {
                guard let name = task.executorName, let date = task.completionDate else { return }
                taskDates.append(date)
                userNames.append(name)
            } else {}
        }
        let fiveTaskDates = taskDates.prefix(5)
        let fiveTaskNames = userNames.prefix(5)
        let taskDateString = fiveTaskDates.joined(separator: "\n")
        let taskUserString = fiveTaskNames.joined(separator: "\n")
        trackerCell.accomplishedDateTextLbl.text = taskDateString
        trackerCell.excutorNameTextLbl.text = taskUserString
    }
}

extension StatisticsViewController: SelectDoneTaskDelegate {
    func doneBtnDidClick(_ cell: UITableViewCell) {
        tableView.reloadData()
    }
    
}
