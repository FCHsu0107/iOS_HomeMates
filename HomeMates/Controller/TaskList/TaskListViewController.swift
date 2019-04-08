//
//  TaskListViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TaskListViewController: HMBaseViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    let taskHeader = TaskListHeaderView()
    
    var taskListTitle: [String] = ["常規任務", "週期性任務"]
    
    var normalTaskList: [TaskObject] = [
                                       TaskObject(taskName: "掃地", image: "home_normal", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1),
                                       TaskObject(taskName: "掃地", image: "home_normal", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1)]
    
    var regularTaskList: [TaskObject] = [TaskObject(taskName: "打預防針", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0),
                                        TaskObject(taskName: "清洗冷氣機濾網", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0),
                                        TaskObject(taskName: "清洗冷氣機濾網", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0),
                                        TaskObject(taskName: "清洗冷氣機濾網", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0),
                                        TaskObject(taskName: "清洗冷氣機濾網", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)

    }
    
}


extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
            return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: return normalTaskList.count
        case 1: return regularTaskList.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }
        
        if indexPath.section == 0 {
            let task = normalTaskList[indexPath.row]
            taskCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: taskCellStatus.assignNormalTask, periodTime: nil)
        } else {
            let task = regularTaskList[indexPath.row]
            
            taskCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: taskCellStatus.assignRegularTask, periodTime: nil)
        }
        return taskCell
    }
    
    
}
