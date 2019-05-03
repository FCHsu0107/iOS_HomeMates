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
    
    let headerTitle = ["一次任務", "每日任務", "常規任務"]
    let guideText = ["(創立任務後可執行一次)", "(預計每天執行的任務，系統將每天加入)"]
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: AddingTaskHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TaskListTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatchGroup.enter()
        FirestoreGroupManager.shared.readDailyTaskList { [weak self] (tasks) in
            self?.dailyTaskList = []
            self?.dailyTaskList = tasks
            self?.dispatchGroup.leave()

        }
        
        dispatchGroup.enter()
        FirestoreGroupManager.shared.readRegularTaskList { [weak self] (tasks) in
            self?.regularTaskList = []
            self?.regularTaskList = tasks
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

}

extension TaskSettingsViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddingTaskHeaderViewCell.self))
//        guard let headerCell = cell as? AddingTaskHeaderViewCell else { return cell }
//        headerCell.loadData(titleText: headerTitle[section], guideText: guideText[section])
//        headerCell.addingTaskBtn.tag = section
//        let newTaskVc = storyboard?.instantiateViewController(withIdentifier: "NewTaskSB") as? AddingTasksViewController
//        newTaskVc?.loadViewIfNeeded()
//        newTaskVc?.view.frame = self.view.frame
//        newTaskVc?.view.backgroundColor = UIColor.clear
//
//        headerCell.taskTypeHandler = { tag in
//
//            if tag == 0 {
//
//                AlertService.addSpecialTask(in: self, completion: { (task) in
//                    FirestoreGroupManager.shared.addTask(for: task)
//                })
//            } else if tag == 1 {
//                AlertService.addDailyTask(in: self, completion: { (task) in
//                    FirestoreGroupManager.shared.addTask(for: task)
//                    FirestoreGroupManager.shared.addDailyTaskList(task: task)
//                })
//            }
//
//        }
//        return headerCell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 76
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if dailyTaskList.count == 0 {
                return 1
            } else {
                return dailyTaskList.count
            }

        default: return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListTableViewCell.self),
                                                 for: indexPath)
        guard let taskCell = cell as? TaskListTableViewCell else { return cell }
        
        let secondCell = tableView.dequeueReusableCell(withIdentifier: String(describing: BlankTableViewCell.self),
                                                       for: indexPath)
        guard let blankCell = secondCell as? BlankTableViewCell else { return secondCell }
        
        switch indexPath.section {
        case 0:
            if dailyTaskList.count == 0 {
                blankCell.loadData(displayText: "請新增任務")
                return blankCell
            } else {
                let dailyTask = dailyTaskList[indexPath.row]
                taskCell.loadData(task: dailyTask)
                return taskCell
            }

        default:
            return cell
 
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard dailyTaskList.count != 0 else { return }
        
        guard editingStyle == .delete else { return }
        let task = dailyTaskList[indexPath.row]
        FirestoreGroupManager.shared.deleteTask(in: .dailyTasksList, docId: task.docId!)
        dailyTaskList.remove(at: indexPath.row)
        tableView.reloadData()

    }
    
}
