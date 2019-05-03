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

    var groupInfo: GroupObject?
    
    override var navigationBarIsHidden: Bool {
        return true
    }

    let taskHeader = TaskListHeaderView()

    var taskListTitle: [String] = ["", "已完成任務", "可接取任務", ""]
    
    var checkTaskList: [TaskObject] = []

    var taskList: [TaskObject] = []
    
    var memberList: [MemberObject] = []
    
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCellWithNib()
        readGroupTaskInfo()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FIRFirestoreSerivce.shared.findMainGroup { [weak self](object) in
            self?.groupInfo = object
        }
        
    }

    private func registerCellWithNib() {
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: AddTaskTableViewCell.self), bundle: nil)
    }
    
    private func readGroupTaskInfo() {
       
        FIRFirestoreSerivce.shared.findMainGroup { [weak self] (object) in
            self?.groupInfo = object
            self?.readTaskLisk()
        }
    }
    
    private func readTaskLisk() {
        FirestoreGroupManager.shared.readGroupMembers(completion: { [weak self] (members) in
            self?.memberList = members
            
            FIRFirestoreSerivce.shared.readAllTasks(comletionHandler: { (tasks) in
                self?.checkTaskList = []
                self?.taskList = []
                for task in tasks {
                    if task.taskStatus == 3 {
                        if members.count == 1 {
                            self?.checkTaskList.append(task)
                        } else if task.executorUid != UserDefaultManager.shared.userUid {
                            self?.checkTaskList.append(task)
                        }
                    } else if task.taskStatus == 1 {
                        self?.taskList.append(task)
                    }
                }
                self?.tableView.reloadData()
            })
            
        })
    }

    @objc func clickSettingBtn() {
        self.performSegue(withIdentifier: "LobbySettingsSegue", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LobbySettingsSegue" {
            guard let nextVc = segue.destination as? LobbySettingsViewController else { return }
            nextVc.groupInfo = groupInfo
            nextVc.memberList = memberList
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
        case 3: return nil

        default :

            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
             return headerView
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 170
        case 3:
            return 0
        default:
            return 60
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
        case 1:
            if checkTaskList.count == 0 {
                return 1
            } else {
                return checkTaskList.count
            }
        case 2:
            if taskList.count == 0 {
                return 1
            } else {
                return taskList.count
            }

        case 3:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
                                                       for: indexPath)
        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                 for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }
        
        switch indexPath.section {
        case 1 :
            if checkTaskList.count == 0 {
                blankCell.loadData(displayText: "待他人完成任務")
                return blankCell
            } else {
                
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
            if taskList.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let task = taskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: .assignNormalTask)
                taskCell.clickHandler = { [weak self] cell, _ in
                    guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
                    
                    guard let updateTask = self?.taskList[indexPath.row] else { return }
                    let task = self?.updateTaskStatus(taskItem: updateTask)
                    FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: task)
                    
                }
                return taskCell
            }
        case 3:
            let thirdCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddTaskTableViewCell.self),
                                                          for: indexPath)
            guard let addingTaskCell = thirdCell as? AddTaskTableViewCell else { return thirdCell}
            
            addingTaskCell.addTaskBtn.addTarget(self, action: #selector(addingTaskPage), for: .touchUpInside)
            return addingTaskCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if indexPath.section != 0 || indexPath.section != 1 {
            guard editingStyle == .delete else { return }
            
            guard taskList.count != 0 else { return }
            
            let task = taskList[indexPath.row]
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
    
    @objc func addingTaskPage() {
        guard let newTaskVc = UIStoryboard.task.instantiateViewController(
            withIdentifier: String(describing: AddingTasksViewController.self))
            as? AddingTasksViewController else { return }
        newTaskVc.modalPresentationStyle = .overFullScreen
        present(newTaskVc, animated: false, completion: nil)
        
    }
}

extension LobbyViewController: UITableViewDelegate {

}
