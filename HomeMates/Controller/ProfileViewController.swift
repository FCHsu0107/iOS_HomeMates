//
//  ProfileViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProfileViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override var navigationBarIsHidden: Bool {
        return true
    }

    let taskHeader = TaskListHeaderView()
    
    let dispatchGroup = DispatchGroup()

    var taskListTitle: [String] = ["", "任務日誌"]
    
    var processTaskList: [TaskObject] = []

    var doneTaskList: [TaskTracker] = []
    
    var taskRecord = TaskRecord()
    
    var userInfo: UserObject?
    
    var goalWithoutTracker: Int?
    
    let messagesView = MessagesView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            
            self?.tableView.endHeaderRefreshing()
        })
        
        tableView.beginHeaderRefreshing()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllInfo()
    }
    
    func registerCell() {
        tableView.jq_registerCellWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TotalPointsTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        
    }
    
    func getAllInfo() {
        dispatchGroup.enter()
        FirestoreUserManager.shared.readUserInfo { [weak self] (user) in
            self?.userInfo = user
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FIRFirestoreSerivce.shared.readDoingTasks { [weak self] (tasks) in
            self?.processTaskList = tasks
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        FirestoreUserManager.shared.readTracker { [weak self] (trackers, flag, goal)  in
            if flag == true {
                guard let trackers = trackers else { return }
                self?.doneTaskList = trackers
                self?.getTotalTime(trackers: trackers, goal: goal)
                
            } else if goal != nil {
                self?.goalWithoutTracker = goal
            }
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    func getTotalTime(trackers: [TaskTracker], goal: Int?) {
        var totalTimes = 0
        var totalPoints = 0
        for track in trackers {
            totalTimes += track.taskTimes
            totalPoints += track.totalPoints
        }
        taskRecord.totalPoints = totalPoints
        taskRecord.totalTimes = totalTimes
        guard let goal = goal else {return }
        taskRecord.goal = goal
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSettingsSegue" {
            guard let nextVc = segue.destination as? ProfileSettingsViewController else { return }
            nextVc.user = userInfo
            if doneTaskList.count == 0 {
                nextVc.goal = goalWithoutTracker
            } else {
                nextVc.goal = taskRecord.goal
            }
            
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderViewCell.self))
            guard let headerCell = cell as? ProfileHeaderViewCell else { return cell}
            guard let name = userInfo?.name else { return headerCell}
            headerCell.loadData(record: taskRecord, userName: name)
            headerCell.settingsBtn.addTarget(self, action: #selector(clickSettingsBtn), for: .touchUpInside)
            return headerCell

        default:
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 220
        default:
            return 60
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
//        case 1:
//            if processTaskList.count == 0 {
//                return 1
//            } else {
//                return processTaskList.count
//            }
        case 1:
            if doneTaskList.count == 0 {
                return 1
            } else {
                return doneTaskList.count
            }
            
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let secondcell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
                                                       for: indexPath)
        guard let blankCell = secondcell as? BlankTableViewCell else { return secondcell }
        
        switch indexPath.section {

//        case 1:
//            if processTaskList.count == 0 {
//                blankCell.loadData(displayText: "請至任務列表接取任務")
//                return blankCell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
//                                                         for: indexPath)
//                guard let taskCell = cell as? TasksTableViewCell else { return cell }
//                let task = processTaskList[indexPath.row]
//                taskCell.loadData(taskObject: task, status: TaskCellStatus.doingTask)
//
//                taskCell.clickHandler = { [weak self] cell, tag in
//                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
//
//                    guard var updateTask = self?.processTaskList[indexPath.row] else { return }
//                    updateTask.taskStatus += tag
//                    if tag == 1 {
//                        let timeStamp = Int(DateProvider.shared.getTimeStamp())
//                        updateTask.completionTimeStamp = timeStamp
//                        self?.dispatchGroup.notify(queue: .main, execute: {
//                            self?.messagesView.showSuccessView(title: "完成任務", body: "待其他成員確認任務後即可獲得積分")
//                        })
//                    }
//
//                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
//                    self?.getAllInfo()
//
//                }
//
//                return taskCell
//            }
            
        case 1:

            if doneTaskList.count == 0 {
                blankCell.loadData(displayText: "待他人確認任務完成")
                return blankCell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: TotalPointsTableViewCell.self),
                    for: indexPath)
                guard let pointsCell = cell as? TotalPointsTableViewCell else { return cell }
                let task = doneTaskList[indexPath.row]
                pointsCell.loadData(tasksTracker: task)
                
                return pointsCell
            }
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func clickSettingsBtn() {
        self.performSegue(withIdentifier: "ProfileSettingsSegue", sender: nil)

    }
}
