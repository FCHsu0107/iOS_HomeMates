//
//  TaskStatusManger.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
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
            
            var updateTask = tasks[indexPath.row]
            updateTask.executorName = UserDefaultManager.shared.userName
            updateTask.executorUid = UserDefaultManager.shared.userUid
            updateTask.taskStatus += tag
            FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            
        case .ongoingTask(let tasks):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            var updateTask = tasks[indexPath.row]
            updateTask.taskStatus += tag
            
            if tag == 1 {
                let timeStamp = Int(DateProvider.shared.getTimeStamp())
                updateTask.completionTimeStamp = timeStamp
                messageView.showSuccessView(title: "完成任務", body: "待其他成員確認任務後即可獲得積分")
                FirestoreGroupManager.shared.readGroupMembers { (members) in
                    for member in members {
                        if let memberToken = member.fcmToken {
                            PushNotificationSender.shared.sendPushNotification(
                                to: memberToken, title: "任務已完成",
                                body: "\(UserDefaultManager.shared.userName!) 已經完成\(updateTask.taskName)任務，快來確認吧！")
                        }
                    }
                }
            }
            
            FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!,
                                                        for: updateTask)
        case .waitingForCheckTask(let tasks):
            messageView.showSuccessView(title: "確認完成任務", body: "可至任務紀錄中查看紀錄")
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            var updateTask = tasks[indexPath.row]
            updateTask.taskStatus += tag
            FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            FirestoreUserManager.shared.addTaskTracker(for: updateTask)
            
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
    
    func identifier() -> String {
        switch self {
        case .acceptableTask(let tasks):
            return verifyCountForIdentifer(tasks.count)
        case .ongoingTask(let tasks):
            return verifyCountForIdentifer(tasks.count)
        case .waitingForCheckTask(let tasks):
            return verifyCountForIdentifer(tasks.count)
        case .createNewTask:
            return String(describing: AddTaskTableViewCell.self)
        default:
            return ""
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
    
    func cellForIndexPath(_ indexPath: IndexPath,
                          tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(), for: indexPath)
        guard let blankCell = cell as? BlankTableViewCell else { return cell }
        guard let taskCell = cell as? TasksTableViewCell else { return cell }
        guard let addTaskCell = cell as? AddTaskTableViewCell else { return cell }
        switch self {
        case .acceptableTask(let tasks)
//        , .ongoingTask(let tasks), .waitingForCheckTask(let tasks)
            :
            if tasks.count == 0 {
                blankCell.loadData(displayText: "請接取任務")
                return blankCell
            } else {
                let task = tasks[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.acceptSpecialTask)
                taskCell.clickHandler = { cell, tag in
                    self.updateStatus(tag: tag, tableView: tableView, cell: cell)
                    
                }
                return taskCell
            }
            
        case .ongoingTask(let tasks):
            if tasks.count == 0 {
                blankCell.loadData(displayText: "待他人完成任務")
                return blankCell
            } else {
                let task = tasks[indexPath.row]
                taskCell.loadData(taskObject: task, status: cellStatus)
                taskCell.clickHandler = { cell, tag in
                    self.updateStatus(tag: tag, tableView: tableView, cell: cell)
                    
                }
                return taskCell
            }
            
        case .waitingForCheckTask(let tasks):
            if tasks.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let task = tasks[indexPath.row]
                taskCell.loadData(taskObject: task, status: cellStatus)
                taskCell.clickHandler = { cell, tag in
                    self.updateStatus(tag: tag, tableView: tableView, cell: cell)
                    
                }
                return taskCell
            }
            
        case .createNewTask:
            
            return addTaskCell

        default:
            return UITableViewCell()
        }

    }

    private func verifyCountForRow(_ count: Int) -> Int {
        if count == 0 {
            return 1
        } else {
            return count
        }
    }
    
    private func verifyCountForIdentifer(_ count: Int) -> String {
        if count == 0 {
            return String(describing: BlankTableViewCell.self)
        } else {
            return String(describing: TasksTableViewCell.self)
        }
    }
    private func verifyCountForCell(_ count: Int) -> UITableViewCell {
        if count == 0 {
            return BlankTableViewCell()
        } else {
            return TasksTableViewCell()
        }
    }
}
