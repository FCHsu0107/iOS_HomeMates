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
    var taskListTitle: [String] = ["", "本月貢獻度", "特殊任務", "已完成任務"]
    var checkTaskList: [TaskObject] = []

    var willDoTaskList: [TaskObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: PointGoalTableViewCell.self), bundle: nil)
        
        FIRFirestoreSerivce.shared.findMainGroup { [weak self] (object) in
            self?.groupInfo = object
            FIRFirestoreSerivce.shared.readCheckTasks { [weak self] (tasks) in
                self?.checkTaskList = []
                for task in tasks {
                    if task.executorUid != UserDefaultManager.shared.userUid {
                        self?.checkTaskList.append(task)
                    } else {}
                }
                self?.tableView.reloadData()
            }
            
            FIRFirestoreSerivce.shared.readAssigningTasks { [weak self] (tasks) in
                self?.willDoTaskList = []
                for task in tasks {
                    if task.taskPriodDay != 1 {
                        self?.willDoTaskList.append(task)
                    }
                    self?.tableView.reloadData()
                }
            }
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
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3: return checkTaskList.count
        case 2: return willDoTaskList.count
        case 1: return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 2, 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                     for: indexPath)
            guard let taskCell = cell as? TasksTableViewCell else { return cell }
           if indexPath.section == 3 {
            let task = checkTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.checkTask)
            
           } else {
            let task = willDoTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.acceptSpecialTask)
    
           }
            return taskCell

        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PointGoalTableViewCell.self), for: indexPath)
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
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
    }
}

extension LobbyViewController: UITableViewDelegate {

}
