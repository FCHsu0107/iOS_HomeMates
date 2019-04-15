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

    //mock data
    var taskListTitle: [String] = ["", "當前任務", "任務日誌"]
    var processTaskList: [TaskObject] = [
        TaskObject(taskName: "拖地",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "阿明",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 2),
        
        TaskObject(taskName: "掃地",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "阿明",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 2),
        
        TaskObject(taskName: "準備早餐",
                   image: "home_normal",
                   publisherName: "System",
                   executorName: "阿明",
                   taskPoint: 1,
                   taskPriodDay: 1,
                   completionDate: nil,
                   taskStatus: 2)]

    var doneTaskList: [TaskRecord] = [
        TaskRecord(taskName: "洗碗", taskImage: "home_normal", executorName: "阿明", taskPoint: 1, taskTimes: 10),
        TaskRecord(taskName: "倒垃圾", taskImage: "home_normal", executorName: "阿明", taskPoint: 1, taskTimes: 5)]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)

    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderViewCell.self))
            guard let headerCell = cell as? ProfileHeaderViewCell else { return cell}
//            headerCell.signoutBtn
            
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
        case 1: return processTaskList.count
        case 2: return doneTaskList.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                 for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }

        switch indexPath.section {

        case 1:

            let task = processTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.doingTask)

            return taskCell

        case 2:

            let task = doneTaskList[indexPath.row]
            taskCell.personalTaskSum(taskName: task.taskName,
                                     image: task.taskImage,
                                     taskTimes: task.taskTimes,
                                     point: task.taskPoint)

            return taskCell

        default:
            return UITableViewCell()
        }
    }
}
