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

    let taskHeader = TaskListHeaderView()
    
    var cellTypes: [TaskStatus] = [.ongoingTask([]), .waitingForCheckTask([]), .acceptableTask([]), .createNewTask]

    var memberList: [MemberObject] = []
    
    let messageView = MessagesView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpNotification()
        headerLoader()
        addNotificationObserver()
    }

    //PushNotification
    private func setUpNotification() {
        PushNotificationManager.shared.registerForPushNotifications()
        PushNotificationManager.shared.updateFirestorePushTokenIfNeeded()
    }
    
    private func setUpTableView() {
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: AddTaskTableViewCell.self), bundle: nil)
    }
    
    func headerLoader() {
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            
            self?.readGroupTaskInfo()
        })

        tableView.beginHeaderRefreshing()
    }
    
    private func readGroupTaskInfo() {
        FIRFirestoreSerivce.shared.findMainGroup { [weak self] (object) in
            self?.groupInfo = object
            self?.readTaskLisk()
        }
    }
    
    private func readTaskLisk() {
        FirestoreGroupManager.shared.readLobbyInfo { [weak self] (members, ongoingTasks, checksTasks, tasks) in
            self?.cellTypes = [.ongoingTask(ongoingTasks),
                               .waitingForCheckTask(checksTasks), .acceptableTask(tasks), .createNewTask]
            self?.memberList = members
            self?.tableView.reloadData()
            self?.tableView.endHeaderRefreshing()
        }
    }

    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(refreshNewTask(noti:)),
            name: Notification.Name(NotificationName.newTask.rawValue), object: nil)
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
    
    @objc func refreshNewTask(noti: Notification) {
        headerLoader()
    }
    
}

extension LobbyViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = cellTypes[section].headerView(title: cellTypes[section].title(), tableView: tableView)
        return headerView

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height = cellTypes[section].heightForHeader()
        return height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellTypes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes[section].numberOfRow()
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch cellTypes[indexPath.section] {

        case .ongoingTask(let tasks):
            let taskCell = setUpCell(tasks: tasks, status: .ongoingTask(tasks), indexPath: indexPath)
            return taskCell

        case .waitingForCheckTask(let tasks):
            let taskCell = setUpCell(tasks: tasks, status: .waitingForCheckTask(tasks), indexPath: indexPath)
            return taskCell

        case .acceptableTask(let tasks):
            let taskCell = setUpCell(tasks: tasks, status: .acceptableTask(tasks), indexPath: indexPath)
            return taskCell

        case .createNewTask:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: AddTaskTableViewCell.self), for: indexPath)
            
            guard let addingTaskCell = cell as? AddTaskTableViewCell else { return cell}

            addingTaskCell.addTaskBtn.addTarget(self, action: #selector(addingTaskPage), for: .touchUpInside)
            return addingTaskCell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch cellTypes[indexPath.section] {
        case .acceptableTask(var tasks):
            guard tasks.count != 0 else { return }
            guard editingStyle == .delete else { return }
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            FirestoreGroupManager.shared.deleteTask(in: .tasks, docId: task.docId!)
            cellTypes[indexPath.section] = .acceptableTask(tasks)
            tableView.reloadData()
        default:
            break
        }
    }

    internal func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch cellTypes[indexPath.section] {
        case .acceptableTask(let tasks):
            if tasks.count == 0 {
                return UITableViewCell.EditingStyle.none
            } else {
                return UITableViewCell.EditingStyle.delete
            }
        default:
            return UITableViewCell.EditingStyle.none
        }
    }
    
    private func setUpCell(tasks: [TaskObject], status: TaskStatus, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }
        
        let secondCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: BlankTableViewCell.self), for: indexPath)
        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell}

        if tasks.count == 0 {
            blankCell.loadData(displayText: status.blankCellTitle())
            return blankCell
        } else {
            let task = tasks[indexPath.row]
            taskCell.loadData(taskObject: task, status: status.cellStatus)
            
            taskCell.clickHandler = { [weak self] cell, tag in
                guard let tableView = self?.tableView else { return }
                self?.cellTypes[indexPath.section].updateStatus(
                    tag: tag, tableView: tableView, cell: cell)
                self?.readTaskLisk()
            }
            return taskCell
        }
    }
    
    @objc func addingTaskPage() {
        guard let newTaskVc = UIStoryboard.task.instantiateViewController(
            withIdentifier: String(describing: AddingTasksViewController.self))
            as? AddingTasksViewController else { return }
        newTaskVc.modalPresentationStyle = .overFullScreen
        present(newTaskVc, animated: false, completion: nil)
    }
}
