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

    var taskListTitle: [String] = ["已接取任務", "已完成任務", "可接取任務"]
    
    var lobbyTaskProvider = LobbyTaskProvider()
    
    var ongoingTaskList: [TaskObject] = []

    var checkTaskList: [TaskObject] = []

    var taskList: [TaskObject] = []

    var memberList: [MemberObject] = []
    
    let messageView = MessagesView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        lobbyTaskProvider.delegate = self
        lobbyTaskProvider.clousure = { [weak self] in
            self?.tableView.reloadData()
        }
        
        setUpTableView()
        setUpNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerLoader()
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
    
    private func headerLoader() {
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            
            self?.readGroupTaskInfo()
        })

        tableView.beginHeaderRefreshing()
    }
    
    private func readGroupTaskInfo() {
        FIRFirestoreSerivce.shared.findMainGroup { [weak self] (object) in
            self?.groupInfo = object
            self?.tableView.endHeaderRefreshing()
//            self?.readTaskLisk()
        }
    }
    
//    private func readTaskLisk() {
//        FirestoreGroupManager.shared.readLobbyInfo { [weak self] (members, ongoingTasks, checksTasks, tasks) in
//            self?.memberList = members
//            self?.ongoingTaskList = ongoingTasks
//            self?.checkTaskList = checksTasks
//            self?.taskList = tasks
//            self?.tableView.reloadData()
//            self?.tableView.endHeaderRefreshing()
//        }
//    }

    @objc func clickSettingBtn() {
        self.performSegue(withIdentifier: "LobbySettingsSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LobbySettingsSegue" {
            guard let nextVc = segue.destination as? LobbySettingsViewController else { return }
            nextVc.groupInfo = groupInfo
//            nextVc.memberList = memberList
        }
    }
    
}

extension LobbyViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {

        case 3: return nil

        default :
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
             return headerView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return lobbyTaskProvider.heightForHeader(section)
//        switch section {
//        case 3:
//            return 0
//        default:
//            return 60
//        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
//        return 4
        return lobbyTaskProvider.numberOfSection()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lobbyTaskProvider.numberOfRow(in: section)
//        switch section {
//        case 0:
//            return verifyCount(ongoingTaskList.count)
//        case 1:
//            return verifyCount(checkTaskList.count)
//        case 2:
//            return verifyCount(taskList.count)
//        case 3:
//            return 1
//        default:
//            return 0
//        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: lobbyTaskProvider.identifier(indexPath: indexPath),
                                                 for: indexPath)
        lobbyTaskProvider.manipulateCell(cell, at: indexPath)
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
//                                                 for: indexPath)
//        guard let taskCell = cell as? TasksTableViewCell else { return cell }
//
//        let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
//                                                       for: indexPath)
//        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell}
//
//        switch indexPath.section {
//
//        case 0:
//            if ongoingTaskList.count == 0 {
//                blankCell.loadData(displayText: "請接取任務")
//                return blankCell
//            } else {
//                let task = ongoingTaskList[indexPath.row]
//
//                taskCell.loadData(taskObject: task, status: TaskCellStatus.doingTask)
//
//                taskCell.clickHandler = { [weak self] cell, tag in
//                    self?.clickOngoingTask(cell: cell, tag: tag)
//                }
//
//                return taskCell
//            }
//        case 1 :
//            if checkTaskList.count == 0 {
//                blankCell.loadData(displayText: "待他人完成任務")
//                return blankCell
//            } else {
//
//                let task = checkTaskList[indexPath.row]
//                taskCell.loadData(taskObject: task, status: TaskCellStatus.checkTask)
//
//                taskCell.clickHandler = { [weak self] cell, _ in
//                    self?.clickCheckTask(cell: cell)
//
//                }
//
//                return taskCell
//            }
//        case 2:
//            if taskList.count == 0 {
//                blankCell.loadData(displayText: "請新增任務")
//                return blankCell
//            } else {
//                let task = taskList[indexPath.row]
//                taskCell.loadData(taskObject: task, status: .acceptSpecialTask)
//
//                taskCell.clickHandler = { [weak self] cell, _ in
//                    self?.clickTask(cell: cell)
//
//                }
//                return taskCell
//            }
//
//        case 3:
//            let thirdCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddTaskTableViewCell.self),
//                                                          for: indexPath)
//            guard let addingTaskCell = thirdCell as? AddTaskTableViewCell else { return thirdCell}
//
//            addingTaskCell.addTaskBtn.addTarget(self, action: #selector(addingTaskPage), for: .touchUpInside)
//            return addingTaskCell
//        default:
//            return UITableViewCell()
//        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            guard editingStyle == .delete else { return }
            guard taskList.count != 0 else { return }
            let task = taskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .tasks, docId: task.docId!)
            taskList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    internal func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 2 && taskList.count != 0 {
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
//    private func clickOngoingTask(cell: UITableViewCell, tag: Int) {
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        var updateTask = ongoingTaskList[indexPath.row]
//        updateTask.taskStatus += tag
//
//        if tag == 1 {
//            let timeStamp = Int(DateProvider.shared.getTimeStamp())
//            updateTask.completionTimeStamp = timeStamp
//            messageView.showSuccessView(title: "完成任務", body: "待其他成員確認任務後即可獲得積分")
//
//            for member in memberList {
//                if let memberToken = member.fcmToken {
//                    PushNotificationSender.shared
//                        .sendPushNotification(to: memberToken,
//                                              title: "任務已完成",
//                                              body: "\(UserDefaultManager.shared.userName!) 已經完成\(updateTask.taskName)任務，快來確認吧！")
//                }
//            }
//        }
//
//        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!,
//                                                    for: updateTask)
//        readTaskLisk()
//    }
//
//    private func clickCheckTask(cell: UITableViewCell) {
//        messageView.showSuccessView(title: "確認完成任務", body: "可至任務紀錄中查看紀錄")
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//        var updateTask = checkTaskList[indexPath.row]
//        updateTask.taskStatus = 4
//        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
//        FirestoreUserManager.shared.addTaskTracker(for: updateTask)
//        readTaskLisk()
//    }
//
//    private func clickTask(cell: UITableViewCell) {
//        messageView.showSuccessView(title: "已接取任務", body: "待任務完成後點選確認鍵")
//        guard let indexPath = tableView.indexPath(for: cell) else { return }
//
//        var updateTask = taskList[indexPath.row]
//        updateTask.executorName = UserDefaultManager.shared.userName
//        updateTask.executorUid = UserDefaultManager.shared.userUid
//        updateTask.taskStatus = 2
//        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
//        readTaskLisk()
//    }
//
    private func verifyCount(_ count: Int) -> Int {
        if count == 0 {
            return 1
        } else {
            return count
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

extension LobbyViewController: ProviderDelegate {
    func dataReady() {
        tableView.reloadData()
    }
    
    
}
