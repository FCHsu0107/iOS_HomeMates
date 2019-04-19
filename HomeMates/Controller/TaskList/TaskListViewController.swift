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

    var taskListTitle: [String] = ["常規任務", "特殊任務"]

    var normalTaskList: [TaskObject] = []

    var regularTaskList: [TaskObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        
        FIRFirestoreSerivce.shared.readAssigningTasks { [weak self] (tasks) in
            self?.normalTaskList = []
            self?.regularTaskList = []
            for task in tasks {
                if task.taskPriodDay == 1 {
                    self?.normalTaskList.append(task)
                } else {
                    self?.regularTaskList.append(task)
                }
            }
            
            self?.tableView.reloadData()
        }

    }

    @IBAction func addTask(_ sender: Any) {
        let newTask = TaskObject(docId: nil,
                                 taskName: "掃地",
                                 image: "home_normal",
                                 publisherName: "System",
                                 executorName: nil,
                                 executorUid: nil,
                                 taskPoint: 1,
                                 taskPriodDay: 1,
                                 completionDate: nil,
                                 taskStatus: 1)
        
        guard let groupId = UserDefaultManager.shared.groupId else { return }
        
        FIRFirestoreSerivce.shared.createSub(for: newTask,
                                             in: .groups,
                                             inDocument: groupId,
                                             inNext: .tasks)
        print("add a task")
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
        switch section {
        case 0: return normalTaskList.count
        case 1: return regularTaskList.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TasksTableViewCell.self),
            for: indexPath)
        
        guard let taskCell = cell as? TasksTableViewCell else { return cell }

        if indexPath.section == 0 {
            
            let task = normalTaskList[indexPath.row]
            
            taskCell.loadData(taskObject: task, status: TaskCellStatus.assignNormalTask)
            
//            taskCell.clickHandler = {[weak self] cell, _ in
//                guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
//
//                guard var updateTask = self?.normalTaskList[indexPath.row] else { return }
//                updateTask.executorName = UserDefaultManager.shared.userName
//                updateTask.executorUid = UserDefaultManager.shared.userUid
//                updateTask.taskStatus = 2
//                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
//            }

        } else {
            
            let task = regularTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.assignRegularTask)

        }
        taskCell.clickHandler = {[weak self] cell, _ in
            guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
            
            if indexPath.section == 0 {
                guard var updateTask = self?.normalTaskList[indexPath.row] else { return }
                updateTask.executorName = UserDefaultManager.shared.userName
                updateTask.executorUid = UserDefaultManager.shared.userUid
                updateTask.taskStatus = 2
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            } else {
                guard var updateTask = self?.regularTaskList[indexPath.row] else { return }
                updateTask.executorName = UserDefaultManager.shared.userName
                updateTask.executorUid = UserDefaultManager.shared.userUid
                updateTask.taskStatus = 2
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            }
            
        }
        
        return taskCell
    }

}
