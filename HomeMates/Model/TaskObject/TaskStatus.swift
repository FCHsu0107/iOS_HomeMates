//
//  TaskStatusManger.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

enum TaskStatus {
    
    case createNewTask
    
    case acceptableTask([TaskObject])
    
    case ongoingTask([TaskObject])
    
    case waitingForCheckTask([TaskObject])
    
    case finishedTask
    
    var cellStatus: TaskCellStatus {
        
        switch self {
        case .acceptableTask:
            return .acceptSpecialTask
        case .ongoingTask:
            return .ongingTask
        case .waitingForCheckTask:
            return .checkTask
        default:
            return .acceptSpecialTask
        }
        
    }

    func updateStatus(tag: Int, tableView: UITableView, cell: UITableViewCell) {
        let messageView = MessagesView()
        
        switch self {
        case .acceptableTask(let tasks):
            messageView.showSuccessView(title: "已接取任務", body: "待任務完成後點選確認鍵")
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let updateTask = tasks[indexPath.row]
            updateAcceptableTaskStatus(task: updateTask, tag: tag)
            
        case .ongoingTask(let tasks):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let updateTask = tasks[indexPath.row]
            updateOngoingTaskStatus(task: updateTask, tag: tag)

        case .waitingForCheckTask(let tasks):
            messageView.showSuccessView(title: "確認完成任務", body: "可至任務紀錄中查看紀錄")
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let updateTask = tasks[indexPath.row]
            updateCheckTaskStatus(task: updateTask, tag: tag)
            
        default:
            break
        }
    }
    
    func title() -> String {
        switch self {
        case .acceptableTask:
            return "可接取任務"
        case .ongoingTask:
            return "已接取任務"
        case .waitingForCheckTask:
            return "完成待確認"
        default:
            return " "
        }
    
    }
    
    func blankCellTitle() -> String {
        switch self {
        case .acceptableTask:
            return "新增任務"
        case .ongoingTask:
            return "請接取任務請"
        case .waitingForCheckTask:
            return "待他人完成任務"
        default:
            return " "
        }
    }
    
    func headerView(title: String, tableView: UITableView) -> UIView? {
        switch self {
        case .acceptableTask, .ongoingTask, .waitingForCheckTask:
            let taskHeader = TaskListHeaderView()
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: title)
            return headerView
        default:
            return nil
        }
    }
    
    func heightForHeader() -> CGFloat {
        switch self {
        case .acceptableTask, .ongoingTask, .waitingForCheckTask:
            return 60
        default:
            return 0
        }
    }
    
    func numberOfRow() -> Int {
        switch self {
        case .acceptableTask(let tasks):
            return verifyCountForRow(tasks.count)
        case .ongoingTask(let tasks):
            return verifyCountForRow(tasks.count)
        case .waitingForCheckTask(let tasks):
            return verifyCountForRow(tasks.count)
        case .createNewTask:
            return 1
        default:
            return 0
        }
    }

    private func verifyCountForRow(_ count: Int) -> Int {
        if count == 0 {
            return 1
        } else {
            return count
        }
    }

    private func updateAcceptableTaskStatus(task: TaskObject, tag: Int) {
        var updateTask = task
        updateTask.executorName = UserDefaultManager.shared.userName
        updateTask.executorUid = UserDefaultManager.shared.userUid
        updateTask.taskStatus += tag
        guard let taskUid = updateTask.docId else { return }
        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: taskUid, for: updateTask)
    }
    
    private func updateOngoingTaskStatus(task: TaskObject, tag: Int) {
        let sender = PushNotificationSender()
        let messageView = MessagesView()
        var updateTask = task
        updateTask.taskStatus += tag
        
        if tag == 1 {
            let timeStamp = Int(DateProvider.shared.getTimeStamp())
            updateTask.completionTimeStamp = timeStamp
            messageView.showSuccessView(title: "完成任務", body: "待其他成員確認任務後即可獲得積分")
            
            guard let userName = UserDefaultManager.shared.userName else { return }
            
            FirestoreGroupManager.shared.readGroupMembers { (members) in
                for member in members where member.userName != userName {
                    if let memberToken = member.fcmToken {
                        sender.sendPushNotification(
                            to: memberToken, title: "任務已完成",
                            body: "\(userName) 已經完成\(updateTask.taskName)任務，快來確認吧！")
                    }
                }
            }
        }
        
        guard let taskUid = updateTask.docId else { return }
        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: taskUid, for: updateTask)
    }
    
    private func updateCheckTaskStatus(task: TaskObject, tag: Int) {
        var updateTask  = task
        updateTask.taskStatus += tag
        guard let taskUid = updateTask.docId else { return }
        FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: taskUid, for: updateTask)
        FirestoreUserManager.shared.addTaskTracker(for: updateTask)
        NotificationCenter.default.post(
            name: Notification.Name(NotificationName.taskIsDone.rawValue), object: nil)
    }
    
}
