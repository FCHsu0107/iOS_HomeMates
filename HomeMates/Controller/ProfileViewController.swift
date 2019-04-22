//
//  ProfileViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProfileViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    override var navigationBarIsHidden: Bool {
        return true
    }

    let taskHeader = TaskListHeaderView()

    //mock data
    var taskListTitle: [String] = ["", "當前任務", "任務日誌"]
    var processTaskList: [TaskObject] = []

    var doneTaskList: [TaskRecord] = [TaskRecord(taskName: "洗碗",
                                                 taskImage: "home_normal",
                                                 executorName: "UserNametest00",
                                                 taskPoint: 2,
                                                 taskTimes: 10),
                                      TaskRecord(taskName: "倒垃圾",
                                                 taskImage: "home_normal",
                                                 executorName: "UserNametest00",
                                                 taskPoint: 2,
                                                 taskTimes: 10)]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TotalPointsTableViewCell.self), bundle: nil)
        
        FIRFirestoreSerivce.shared.readDoingTasks { [weak self] (tasks) in
            self?.processTaskList = tasks
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSettingsSegue" {
            guard let nextVc = segue.destination as? ProfileSettingsViewController else { return }
            print(nextVc)
        }
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileHeaderViewCell.self))
            guard let headerCell = cell as? ProfileHeaderViewCell else { return cell}
            headerCell.settingsBtn.addTarget(self, action: #selector(clickSettingsBtn), for: .touchUpInside)
            return headerCell

        default:
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 220
        default:
            return 40
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return processTaskList.count
        case 2: return doneTaskList.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self),
                                                     for: indexPath)
            guard let taskCell = cell as? TasksTableViewCell else { return cell }
            let task = processTaskList[indexPath.row]
            taskCell.loadData(taskObject: task, status: TaskCellStatus.doingTask)
            
            taskCell.clickHandler = { [weak self] cell, tag in
                guard let indexPath = self?.tableView.indexPath(for: cell) else { return }

                guard var updateTask = self?.processTaskList[indexPath.row] else { return }
                updateTask.taskStatus += tag
                if tag == 1 {
                    let timeStamp = Int(DateProvider.shared.getTimeStamp())
                    updateTask.compleyionTimeStamp = timeStamp
                    
                }
                FIRFirestoreSerivce.shared.updateTaskStatus(taskUid: updateTask.docId!, for: updateTask)
            }

            return taskCell

        case 2:

            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TotalPointsTableViewCell.self),
                                                     for: indexPath)
            guard let pointsCell = cell as? TotalPointsTableViewCell else { return cell }
            let task = doneTaskList[indexPath.row]
            pointsCell.loadData(tasksTracker: task)
            
            return pointsCell

        default:
            return UITableViewCell()
        }
    }
    
    @objc func clickSettingsBtn() {
        self.performSegue(withIdentifier: "ProfileSettingsSegue", sender: nil)
    }
}
