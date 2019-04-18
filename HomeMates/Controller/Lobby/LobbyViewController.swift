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
    var checkTaskList: [TaskObject] = [
        TaskObject(taskName: "拖地",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "Mother",
                   executorUid: "Mother",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 3),
        TaskObject(taskName: "掃地",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "Daddy",
                   executorUid: "Daddy",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 3),
        TaskObject(taskName: "掃地",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "Daddy",
                   executorUid: "Daddy",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 3)]

    var willDoTaskList: [TaskObject] = [
        TaskObject(taskName: "打預防針",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: nil,
                   executorUid: nil,
                   taskPoint: 2,
                   taskPriodDay: 0,
                   completionDate: nil,
                   taskStatus: 1),
        TaskObject(taskName: "清洗冷氣機濾網",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: nil,
                   executorUid: nil,
                   taskPoint: 2,
                   taskPriodDay: 0,
                   completionDate: nil,
                   taskStatus: 1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        
        print("-----------------")
        FIRFirestoreSerivce.shared.findMainGroup { (object) in
            self.groupInfo = object
            self.tableView.reloadData()
        }
        
        print("-------------------end of viewDidLoad")
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

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                 for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }

        switch indexPath.section {
        case 2, 3:

           if indexPath.section == 3 {
            let task = checkTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.checkTask)
            
           } else {
            let task = willDoTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.acceptSpecialTask)
    
           }
            return taskCell

        case 1:
            taskCell.showContributionView(member: "小明",
                                          memberImage: "home_normal",
                                          personalTotalPoints: 40,
                                          persent: 20)

            return taskCell

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
