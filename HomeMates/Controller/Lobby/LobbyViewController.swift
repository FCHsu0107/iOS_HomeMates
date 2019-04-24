//
//  LobbyViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbyViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            tableView.delegate = self

            tableView.dataSource = self
        }
    }

    var groupInfo: GroupObject? = nil {
        didSet {
            print(groupInfo as Any)
        }
    }
    
    override var navigationBarIsHidden: Bool {
        return true
    }

    let taskHeader = TaskListHeaderView()

    //mock data
    var taskListTitle: [String] = ["", "已完成任務", "本月目標達成率"]
    var checkTaskList: [TaskObject] = []

    var willDoTaskList: [TaskObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: PointGoalTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        
        FIRFirestoreSerivce.shared.findMainGroup { [weak self] (object) in
            self?.groupInfo = object
            FIRFirestoreSerivce.shared.readCheckTasks { [weak self] (tasks) in
                self?.checkTaskList = []
                for task in tasks {
                    if task.executorUid != UserDefaultManager.shared.userUid {
                        self?.checkTaskList.append(task)
                    } else {}
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            }
            
        }
    }

    @objc func clickSettingBtn() {
        self.performSegue(withIdentifier: "LobbySettingsSegue", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LobbySettingsSegue" {
            guard let nextVc = segue.destination as? LobbySettingsViewController else { return }
            print(nextVc)
        }
    }
}

extension LobbyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LobbyHeaderCell.self))
            guard let headerCell = cell as? LobbyHeaderCell else { return cell}
            headerCell.groupInfo = groupInfo
            headerCell.settingsBtn.addTarget(self, action: #selector(clickSettingBtn), for: .touchUpInside)
            return headerCell

        default :

            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
             return headerView
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 200
        default:
            return 40
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
        case 1:
            if checkTaskList.count == 0 {
                return 1
            } else {
                return checkTaskList.count
            }
        case 2: return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
                                                       for: indexPath)
        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell}
        
        switch indexPath.section {
        case 1 :
            if checkTaskList.count == 0 {
                blankCell.loadData(displayText: "待他人完成任務")
                return blankCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                         for: indexPath)
                guard let taskCell = cell as? TasksTableViewCell else { return cell }
                
                let task = checkTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.checkTask)
                taskCell.clickHandler = { [weak self] cell, _ in
                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                    guard var updateTask = self?.checkTaskList[indexPath.row] else { return }
                    updateTask.taskStatus = 4
                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
                    FirestoreUserManager.shared.addTaskTracker(for: updateTask)
                }
                
                return taskCell
            }
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PointGoalTableViewCell.self),
                                                     for: indexPath)
            guard let goalCell = cell as? PointGoalTableViewCell else { return cell }
            goalCell.showContributionView(member: "小明",
                                          memberImage: "home_normal",
                                          personalTotalPoints: 40,
                                          persent: 20)

            return goalCell

        default:
            return UITableViewCell()
        }
    }
    
}

extension LobbyViewController: UITableViewDelegate {

}
