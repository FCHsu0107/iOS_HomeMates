//
//  LobbyViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbyViewController: HMBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    {
    
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
    var taskListTitle: [String] = ["","已完成任務", "特殊任務", "本月貢獻度"]
    var checkTaskList: [TaskObject] = [
        TaskObject(taskName: "拖地", image: "home_normal", publisherName: "System", executorName: "Mother", taskPoint: 1, taskPriodDay: 1),
                                       TaskObject(taskName: "掃地", image: "home_normal", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1),
                                       TaskObject(taskName: "掃地", image: "home_normal", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1)]
    
    var willDoTaskList: [TaskObject] = [
        TaskObject(taskName: "打預防針", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0),
//                                        TaskObject(taskName: "清洗冷氣機濾網", image: "home_normal", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        
    }
    
}


extension LobbyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LobbyHeaderCell.self))
            guard let headerCell = cell as? LobbyHeaderCell else { return cell}
            headerCell.groupID.text = "Home ID: 8989889"
            return headerCell
            
        default :
            
            let headerView = taskHeader.taskTitle(tableView: tableView, titleText: taskListTitle[section])
             return headerView
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 200
        case 1, 2, 3:
            return 40
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1: return checkTaskList.count
        case 2: return willDoTaskList.count
        case 3: return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
        guard let taskCell = cell as? TasksTableViewCell else { return cell }
        
        switch indexPath.section {
        case 1, 2:
           
           if indexPath.section == 1 {
            let task = checkTaskList[indexPath.row]
            taskCell.loadData(image: task.image, member: task.executorName ?? "神秘人" , task: task.taskName, point: task.taskPoint, status: taskCellStatus.checkTask, periodTime: nil)
            
           } else {
            let task = willDoTaskList[indexPath.row]
            taskCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: taskCellStatus.acceptSpecialTask, periodTime: nil)
           }
            return taskCell
            
        case 3:
            taskCell.showContributionView(member: "小明", memberImage: "home_normal", personalTotalPoints: 40, persent: 20)
            
            return taskCell
            
        default:
            return UITableViewCell()
        }
    }
    

}


extension LobbyViewController: UITableViewDelegate {

}

