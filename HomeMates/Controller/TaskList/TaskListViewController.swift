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
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        
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
        case 0:
            if specialTaskList.count == 0 {
                return 1
            } else {
                return specialTaskList.count
            }
        case 1:
            if normalTaskList.count == 0 {
                return 1
            } else {
                return normalTaskList.count
            }
        case 2:
            if regularTaskList.count == 0 {
                return 1
            } else {
                return regularTaskList.count
            }
            
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TasksTableViewCell.self),
            for: indexPath)
        
        guard let taskCell = cell as? TasksTableViewCell else { return cell }

        let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
                                                       for: indexPath)
        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell}
        
        switch indexPath.section {
        case 0:
            if specialTaskList.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let task = specialTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: .assignNormalTask)
                taskCell.clickHandler = { [weak self] cell, _ in
                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                    
                    guard let updateTask = self?.specialTaskList[indexPath.row] else { return }
                    let task = self?.updateTaskStatus(taskItem: updateTask)
                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
 
                }
                return taskCell
            }
        case 1:
            if normalTaskList.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let task = normalTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.assignNormalTask)
                taskCell.clickHandler = { [weak self] cell, _ in
                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                    
                    guard let updateTask = self?.normalTaskList[indexPath.row] else { return }
                    let task = self?.updateTaskStatus(taskItem: updateTask)
                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
                    
                }
                return taskCell
            }
        case 2:
            if regularTaskList.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let task = regularTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.assignRegularTask)
                taskCell.clickHandler = { [weak self] cell, _ in
                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                    
                    guard let updateTask = self?.regularTaskList[indexPath.row] else { return }
                    let task = self?.updateTaskStatus(taskItem: updateTask)
                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
                    
                }
                return taskCell
            }
        default:
            return taskCell
        }
        
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if indexPath.section == 0 {
            guard specialTaskList.count != 0 else { return }
            
            let task = specialTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .tasks, docId: task.docId!)
            
        } else if indexPath.section == 1 {
            guard normalTaskList.count != 0 else { return }
            
            let task = normalTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .tasks, docId: task.docId!)
        } else {
            guard regularTaskList.count != 0 else { return }
            
            let task = regularTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .tasks, docId: task.docId!)
        }
    }
    
    private func updateTaskStatus(taskItem: TaskObject) -> TaskObject {
        var task = taskItem
        task.executorName = UserDefaultManager.shared.userName
        task.executorUid = UserDefaultManager.shared.userUid
        task.taskStatus = 2
        return task
    }
}
