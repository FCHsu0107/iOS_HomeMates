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
    
    var dailyTaskList: [TaskObject] = [ TaskObject(docId: nil,
                                                   taskName: "洗碗",
                                                   image: "home_normal",
                                                   publisherName: "System",
                                                   executorName: nil,
                                                   executorUid: nil,
                                                   taskPoint: 1,
                                                   taskPriodDay: 1,
                                                   compleyionTimeStamp: nil,
                                                   taskStatus: 1),
                                        TaskObject(docId: nil,
                                                   taskName: "煮午餐",
                                                   image: "home_normal",
                                                   publisherName: "System",
                                                   executorName: nil,
                                                   executorUid: nil,
                                                   taskPoint: 1,
                                                   taskPriodDay: 1,
                                                   compleyionTimeStamp: nil,
                                                   taskStatus: 1),
                                        TaskObject(docId: nil,
                                                   taskName: "掃地",
                                                   image: "home_normal",
                                                   publisherName: "System",
                                                   executorName: nil,
                                                   executorUid: nil,
                                                   taskPoint: 1,
                                                   taskPriodDay: 1,
                                                   compleyionTimeStamp: nil,
                                                   taskStatus: 1)]
    
    var regularTaskList: [TaskObject] = [ TaskObject(docId: nil,
                                                     taskName: "倒垃圾",
                                                     image: "home_normal",
                                                     publisherName: "System",
                                                     executorName: nil,
                                                     executorUid: nil,
                                                     taskPoint: 1,
                                                     taskPriodDay: 3,
                                                     compleyionTimeStamp: nil,
                                                     taskStatus: 1),
                                          TaskObject(docId: nil,
                                                     taskName: "洗衣服",
                                                     image: "home_normal",
                                                     publisherName: "System",
                                                     executorName: nil,
                                                     executorUid: nil,
                                                     taskPoint: 1,
                                                     taskPriodDay: 7,
                                                     compleyionTimeStamp: nil,
                                                     taskStatus: 1),
                                          TaskObject(docId: nil,
                                                     taskName: "洗床單",
                                                     image: "home_normal",
                                                     publisherName: "System",
                                                     executorName: nil,
                                                     executorUid: nil,
                                                     taskPoint: 1,
                                                     taskPriodDay: 14,
                                                     compleyionTimeStamp: nil,
                                                     taskStatus: 1)]
    
    let headerTitle = ["特殊任務", "每日任務", "常規任務"]
    let guideText = ["(非常規任務，創立任務後可執行一次)", "(每天執行的任務，系統將每天加入任務列表中)", "(定期執行的任務，系統將定期加入任務列表中)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: AddingTaskHeaderViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: TaskListTableViewCell.self), bundle: nil)

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
            //加入任務會因為不同的 tag, taskPriodDay 有所不同
            // tag == 0, taskPriodDay = 1
            // tag == 1, taskPriodDay = 依照選擇的天數
            // tag == 2, taskPriodDay = 0
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskListTableViewCell.self), for: indexPath)
        guard let taskCell = cell as? TaskListTableViewCell else { return cell }
        switch indexPath.section {
        case 1:
            taskCell.loadData(task: dailyTaskList[indexPath.row])
            return taskCell
        case 2:
            taskCell.loadData(task: regularTaskList[indexPath.row], isDaliyTask: false)
            return taskCell
        default:
            return cell
 
        }
//        return UITableViewCell()
    }
    
}
