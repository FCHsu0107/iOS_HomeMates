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

    var taskListTitle: [String] = ["特殊任務", "每日任務", "常規任務"]

    var normalTaskList: [TaskObject] = []

    var regularTaskList: [TaskObject] = []
    
    var specialTaskList: [TaskObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        
        FIRFirestoreSerivce.shared.readAssigningTasks { [weak self] (tasks) in
            self?.normalTaskList = []
            self?.regularTaskList = []
            self?.specialTaskList = []
            for task in tasks {
                if task.taskPriodDay == 1 {
                    self?.normalTaskList.append(task)
                } else if task.taskPriodDay == 0 {
                    self?.specialTaskList.append(task)
                } else {
                     self?.regularTaskList.append(task)
                }
            }
            
            self?.tableView.reloadData()
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            guard segue.destination is TaskSettingsViewController else { return
            }
        }
    }
    
    @IBAction func addTask(_ sender: Any) {
       performSegue(withIdentifier: "AddTaskSegue", sender: nil)
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
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return specialTaskList.count
        case 1: return normalTaskList.count
        case 2: return regularTaskList.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TasksTableViewCell.self),
            for: indexPath)
        
        guard let taskCell = cell as? TasksTableViewCell else { return cell }

        if indexPath.section == 1 {
            
            let task = normalTaskList[indexPath.row]
            
            taskCell.loadData(taskObject: task, status: TaskCellStatus.assignNormalTask)
            

        } else if indexPath.section == 2 {
            
            let task = regularTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.assignRegularTask)

        } else {
            let task = specialTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: .assignNormalTask)
        }
        
        taskCell.clickHandler = {[weak self] cell, _ in
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            
            if indexPath.section == 1 {
                guard let updateTask = self?.normalTaskList[indexPath.row] else { return }
                let task = self?.updateTaskStatus(taskItem: updateTask)
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
                
            } else if indexPath.section == 2 {
                guard let updateTask = self?.regularTaskList[indexPath.row] else { return }
                let task = self?.updateTaskStatus(taskItem: updateTask)
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
            } else {
                guard let updateTask = self?.specialTaskList[indexPath.row] else {
                    return
                }
                let task = self?.updateTaskStatus(taskItem: updateTask)
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
            }
            
        }
        
        return taskCell
    }

    private func updateTaskStatus(taskItem: TaskObject) -> TaskObject {
        var task = taskItem
        task.executorName = UserDefaultManager.shared.userName
        task.executorUid = UserDefaultManager.shared.userUid
        task.taskStatus = 2
        return task
    }
}
