//
//  TaskStatusManger.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

enum TaskStatus: Int {
    
    case createNewTask = 0
    
    case acceptableTask = 1
    
    case ongoingTask = 2
    
    case waitingForCheckTask = 3
    
    case finishedTask = 4
    
    func updateStatus(tag: Int, tableView: UITableView, cell: UITableViewCell, tasks: [TaskObject]) {
        let messageView = MessagesView()
        switch self {
        case .acceptableTask:
            messageView.showSuccessView(title: "已接取任務", body: "待任務完成後點選確認鍵")
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            var updateTask = tasks[indexPath.row]
            updateTask.executorName = UserDefaultManager.shared.userName
            updateTask.executorUid = UserDefaultManager.shared.userUid
            updateTask.taskStatus += tag
            FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            
        case .ongoingTask:
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
        case .waitingForCheckTask:
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
    
//    func numberOfRow(tasks: [TaskObject]) -> String {
//        switch self {
//        case .acceptableTask, .ongoingTask, .waitingForCheckTask:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
    
//    func identifier(tasks: [TaskObject]) -> String {
//
//        switch self {
//
//        case .acceptableTask, .ongoingTask, .waitingForCheckTask:
//            return verifyCountForIdentifer(tasks.count)
//
//        case .createNewTask:
//            return String(describing: AddTaskTableViewCell.self)
//            
//        default:
//            return String(describing: BlankTableViewCell.self)
//        }
//    }

//    func cellForIndexPath(_ indexPath: IndexPath,
//                          tableView: UITableView, tasks: [TaskObject]) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier(tasks: tasks), for: indexPath)
//        switch self {
//        case .acceptableTask, .ongoingTask, .waitingForCheckTask:
//            if
//        default:
//            <#code#>
//        }
//
//    }
    
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
}
