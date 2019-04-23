//
//  TaskListSettingViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/20.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TaskSettingsViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var dailyTaskList: [TaskObject] = []
    
    var regularTaskList: [TaskObject] = []
    
    let headerTitle = ["特殊任務", "每日任務", "常規任務"]
    let guideText = ["(非常規任務，創立任務後可執行一次)", "(每天執行的任務，系統將每天加入任務列表中)", "(定期執行的任務，系統將定期加入任務列表中)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: AddingTaskHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TaskListTableViewCell.self), bundle: nil)
        
        FirestoreGroupManager.shared.readDailyTaskList { [weak self] (tasks) in
            self?.dailyTaskList = []
            
            self?.dailyTaskList = tasks

            self?.tableView.reloadData()
        }
        
        FirestoreGroupManager.shared.readRegularTaskList { [weak self] (tasks) in
            self?.regularTaskList = []
            self?.regularTaskList = tasks
            self?.tableView.reloadData()
        }

    }

}

extension TaskSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddingTaskHeaderViewCell.self))
        guard let headerCell = cell as? AddingTaskHeaderViewCell else { return cell }
        headerCell.loadData(titleText: headerTitle[section], guideText: guideText[section])
        headerCell.addingTaskBtn.tag = section
        headerCell.taskTypeHandler = { tag in
            
            print(tag)
            if tag == 0 {
                AlertService.addSpecialTask(in: self, completion: { (task) in
                    FirestoreGroupManager.shared.addTask(for: task)
                })
            } else if tag == 1 {
                AlertService.addDailyTask(in: self, completion: { (task) in
                    FirestoreGroupManager.shared.addTask(for: task)
                    FirestoreGroupManager.shared.addDailyTaskList(task: task)
                })
            } else {
                AlertService.addRegularTask(in: self, completion: { (task) in
                    FirestoreGroupManager.shared.addTask(for: task)
                    FirestoreGroupManager.shared.addRegularTaskList(task: task)
                })
            }

        }
        return headerCell
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            if dailyTaskList.count == 0 {
                return 1
            } else {
                return dailyTaskList.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListTableViewCell.self),
                                                 for: indexPath)
        guard let taskCell = cell as? TaskListTableViewCell else { return cell }
        switch indexPath.section {
        case 1:
            if dailyTaskList.count == 0 {
                return UITableViewCell()
            } else {
                let dailyTask = dailyTaskList[indexPath.row]
                taskCell.loadData(task: dailyTask)
                return taskCell
            }
            
        case 2:
            if regularTaskList.count == 0 {
                return UITableViewCell()
            } else {
                let regularTask = regularTaskList[indexPath.row]
                taskCell.loadData(task: regularTask, isDaliyTask: false)
                return taskCell
            }
            
        default:
            return cell
 
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        if indexPath.section == 1 {
            guard dailyTaskList.count != 0 else { return }
            
            let task = dailyTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .dailyTasksList, docId: task.docId!)
        } else if indexPath.section == 2 {
            guard regularTaskList.count != 0 else { return }
            let task = regularTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .regularTaskList, docId: task.docId!)
        }
     
        
    }
    
}
