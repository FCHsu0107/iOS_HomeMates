//
//  ProfileViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProfileViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override var navigationBarIsHidden: Bool {
        return true
    }

    let taskHeader = TaskListHeaderView()
    
    let dispatchGroup = DispatchGroup()

    var taskListTitle: [String] = ["", " 任務日誌"]

    var doneTaskList: [TaskTracker] = []
    
    var taskRecord = TaskRecord()
    
    var userInfo: UserObject?
    
    var goalWithoutTracker: Int?
    
    let messagesView = MessagesView()

    let profileProvider = ProfileProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        headerLoader()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.jq_registerCellWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TotalPointsTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        
    }
    
    private func headerLoader() {
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.getAllInfo()
        })
        tableView.beginHeaderRefreshing()
    }
    
    private func getAllInfo() {
        dispatchGroup.enter()
        profileProvider.readUserInfo { [weak self] (result) in
            switch result {
            case .success(let user):
                self?.userInfo = user
                self?.dispatchGroup.leave()
            case .failure:
                self?.dispatchGroup.leave()
            }
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
            self.tableView.endHeaderRefreshing()
        }
    }

    private func getTotalTime(trackers: [TaskTracker], goal: Int?) {
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
  
        switch indexPath.section {
            
        case 1:

            if doneTaskList.count == 0 {
                let secondcell = tableView.dequeueReusableCell(
                    withIdentifier: String(describing: BlankTableViewCell.self), for: indexPath)
                guard let blankCell = secondcell as? BlankTableViewCell else { return secondcell }
                
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
