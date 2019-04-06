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
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override var navigationBarIsHidden: Bool {
        return true
    }
    
    //mock data
    var taskListTitle: [String] = ["","當前任務", "任務日誌"]
    var processTaskList: [TaskObject] = [TaskObject(taskName: "拖地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal")]
//    var doneTaskList: [Any] = []

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)

    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskListTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Noto Sans Chakma Regular", size: 18)
        header.textLabel?.textColor = UIColor.Y4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        case 1, 2:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return processTaskList.count
        case 2: return 3
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderViewCell.self), for: indexPath)
            guard let headerCell = cell as? ProfileHeaderViewCell else { return cell}
            return headerCell
        case 1, 2:

            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
            guard let taskCell = cell as? TasksTableViewCell else { return cell }
            
            let task = processTaskList[indexPath.row]
            taskCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: taskCellStatus.doingTask, doneTimes: 0)
            return taskCell
        default:
            return UITableViewCell()
        }
    }
    
    
}
