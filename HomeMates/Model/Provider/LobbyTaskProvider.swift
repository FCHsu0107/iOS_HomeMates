//
//  LobbyTaskProvider.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/9.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

protocol ProviderDelegate: AnyObject {
    func dataReady()
}

class LobbyTaskProvider {
    
    private enum CellType {
        
        case ongoingTasks(Int)
        
        case waitingForCheckTasks(Int)
        
        case acceptableTasks(Int)
        
        case addingANewTask
        
        func title() -> String {
            switch self {
            case .ongoingTasks: return "已接取任務"
                
            case .waitingForCheckTasks: return "已完成任務"
                
            case .acceptableTasks: return "可接取任務"
                
            case .addingANewTask: return ""
            }
        }
        func heightForHeader() -> CGFloat {
            switch self {
            case .ongoingTasks, .acceptableTasks, .waitingForCheckTasks: return 60
            case .addingANewTask: return 0
            }
        }
    }
    
    var clousure: (() -> Void)?
    
    weak var delegate: ProviderDelegate?
    
    init() {
        
        dispatchGroup.enter()
        fetchData()
        dispatchGroup.notify(queue: .main) {
            print("get all task data")
            print(self.checkTaskList)
            print(self.ongoingTaskList)
            print(self.taskList)
            self.delegate?.dataReady()
            self.clousure?()
        }
    }
    
    let dispatchGroup = DispatchGroup()
    
    func numberOfSection() -> Int {
        return datas.count
    }
    
    func numberOfRow(in section: Int) -> Int {
        return count(type: datas[section])
    }
    
    func titleFofSection(_ section: Int) -> String {
        return datas[section].title()
    }
    
    func heightForHeader(_ section: Int) -> CGFloat {
        return datas[section].heightForHeader()
    }
    
    func identifier(indexPath: IndexPath) -> String {
        return identifier(type: datas[indexPath.section])
    }
    
    func fetchData() {
        FirestoreGroupManager.shared.readGroupMembers(completion: { (members) in
            self.memberList = members
            
            FIRFirestoreSerivce.shared.readAllTasks(completionHandler: { (tasks) in
                self.ongoingTaskList = []
                self.checkTaskList = []
                self.taskList = []
                for task in tasks {
                    switch task.taskStatus {
                    case 1:
                        self.taskList.append(task)
                    case 2:
                        if task.executorUid == UserDefaultManager.shared.userUid {
                            self.ongoingTaskList.append(task)
                        }
                    case 3:
                        if members.count == 1 {
                            self.checkTaskList.append(task)
                        } else if task.executorUid != UserDefaultManager.shared.userUid {
                            self.checkTaskList.append(task)
                        }
                    default: break
                    }
                }
                self.datas = [.ongoingTasks(self.ongoingTaskList.count),
                              .waitingForCheckTasks(self.checkTaskList.count),
                              .acceptableTasks(self.taskList.count),
                              .addingANewTask]
               self.dispatchGroup.leave()
            })
        })
    }
    
    func manipulateCell(_ cell: UITableViewCell, at indexPath: IndexPath)  {
        print("++++++++++++Load DATA++++++++++")
        switch datas[indexPath.section] {
        case .ongoingTasks(let count):
            if count == 0 {
                guard let blankCell = cell as? BlankTableViewCell else { return }
                blankCell.loadData(displayText: "請接取任務")
            } else {
                guard let taskCell = cell as? TasksTableViewCell else { return }
                let task = ongoingTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.doingTask)
            }
        case .waitingForCheckTasks(let count):
            if count == 0 {
                guard let blankCell = cell as? BlankTableViewCell else { return }
                blankCell.loadData(displayText: "待他人完成任務")
            } else {
                guard let taskCell = cell as? TasksTableViewCell else { return }
                let task = checkTaskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.checkTask)
            }
        case .acceptableTasks(let count):
            if count == 0 {
                guard let blankCell = cell as? BlankTableViewCell else { return }
                blankCell.loadData(displayText: "請新增任務")
            } else {
                guard let taskCell = cell as? TasksTableViewCell else { return }
                let task = taskList[indexPath.row]
                taskCell.loadData(taskObject: task, status: TaskCellStatus.acceptSpecialTask)
            }
        case .addingANewTask:
            guard cell is AddTaskTableViewCell else { return }
            
        }
    }
    
    var memberList: [MemberObject] = []
    
    private var ongoingTaskList: [TaskObject] = []
    
    private var checkTaskList: [TaskObject] = []
    
    var taskList: [TaskObject] = []
    
    private var datas: [CellType] = [.ongoingTasks(0),
                                     .waitingForCheckTasks(0),
                                     .acceptableTasks(0),
                                     .addingANewTask]
    
    private func identifier(type: CellType) -> String {
        
        switch type {
            
        case .ongoingTasks(let count): return verifyCount(count)
            
        case .waitingForCheckTasks(let count): return verifyCount(count)
           
        case .acceptableTasks(let count): return verifyCount(count)
            
        case .addingANewTask:
            return String(describing: AddTaskTableViewCell.self)
        }
    }
    
    private func verifyCount(_ count: Int) -> String {
        if count == 0 {
            return String(describing: BlankTableViewCell.self)
        } else {
            return String(describing: TasksTableViewCell.self)
        }
    }
    
    private func count(type: CellType) -> Int {
        switch type {
        case .ongoingTasks(let count):
            if count == 0 {
                return 1
            } else {
                return count
            }
        case .waitingForCheckTasks(let count):
            if count == 0 {
                return 1
            } else {
                return count
            }
        case .acceptableTasks(let count):
            if count == 0 {
                return 1
            } else {
                return count
            }
        case .addingANewTask: return 1
        }
    }
    
}
