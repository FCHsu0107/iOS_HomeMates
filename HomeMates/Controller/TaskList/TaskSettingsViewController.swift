//
//  TaskListSettingViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/20.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TaskSettingsViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView! 
    
    var dailyTaskList: [TaskObject] = []
    
    var regularTaskList: [TaskObject] = []
    
    let headerTitle = ["一次任務", "每日任務", "常規任務"]
    let guideText = ["(創立任務後可執行一次)", "(預計每天執行的任務，系統將每天加入)"]
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        headerLoder()
    }
    
    private func readTaskInfo() {
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
            self.tableView.endHeaderRefreshing()
        }
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.jq_registerCellWithNib(identifier: String(describing: TaskListTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: BlankTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: AddTaskTableViewCell.self), bundle: nil)
    }
    
    private func headerLoder() {
        tableView.addRefreshHeader(refreshingBlock: { [weak self] in
            self?.readTaskInfo()
        })
        
        tableView.beginHeaderRefreshing()
    }
}

extension TaskSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if dailyTaskList.count == 0 {
                return 1
            } else {
                return dailyTaskList.count
            }

        case 1: return 1
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

        case 1:
            let thirdCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddTaskTableViewCell.self),
                                                          for: indexPath)
            guard let addTaskCell = thirdCell as? AddTaskTableViewCell else { return thirdCell }
            addTaskCell.addTaskBtn.addTarget(self, action: #selector(addingTaskPage), for: .touchUpInside)
            return addTaskCell
        default:
            return cell
 
        }
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard dailyTaskList.count != 0 else { return }
            
            guard editingStyle == .delete else { return }
            let task = dailyTaskList[indexPath.row]
            FirestoreGroupManager.shared.deleteTask(in: .dailyTasksList, docId: task.docId!)
            dailyTaskList.remove(at: indexPath.row)
            tableView.reloadData()
        default:
            break
        }
    }
    
    public func tableView(_ tableView: UITableView,
                          editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 && dailyTaskList.count != 0 {
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
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
