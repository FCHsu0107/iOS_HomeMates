//
//  LobbyViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    {
    
        didSet {
            tableView.delegate = self

            tableView.dataSource = self
        }
    }
    
    //mock data
    
    var taskListTitle: [String] = ["","完成任務", "任務清單"]
    var checkTaskList: [TaskObject] = [TaskObject(taskName: "拖地", publisherName: "System", executorName: "Mother", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal")]
    
    var willDoTaskList: [TaskObject] = [TaskObject(taskName: "打預防針", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
        tableView.jq_registerHeaderWithNib(identifier: String(describing: LobbyHeaderView.self), bundle: nil)
        tableView.jq_registerHeaderWithNib(identifier: String(describing: TaskHeaderView.self), bundle: nil)
        tableView.jq_registerCellWithNib(identifier: String(describing: LobbyHeaderCell.self), bundle: nil)
        
    }
    


}


extension LobbyViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskListTitle[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.backgroundColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Noto Sans Chakma Regular", size: 18)
        header.textLabel?.textColor = UIColor.Y4
    }
    

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            guard let header = view as? LobbyHeaderView else { return nil }
//            header.groupName.text = "testName"
//            return header
//
//        case 1, 2:
//
//            guard let subHeader = view as? TaskHeaderView else { return nil}
//            subHeader.taskHeaderText.text = taskListTitle[section]
//            return subHeader
//
//        default:
//            return nil
//        }
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNormalMagnitude
        case 1, 2:
            return 40
        default:
            return 0
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
        case 0: return 1
        case 1: return checkTaskList.count
        case 2: return willDoTaskList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LobbyHeaderCell.self), for: indexPath)
            guard let headerCell = cell as? LobbyHeaderCell else { return cell}
            headerCell.groupID.text = "Here is test ID"
            return headerCell
            
        case 1:
           let task = checkTaskList[indexPath.row]
           let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
            guard let checkCell = cell as? TasksTableViewCell else { return cell }

            checkCell.loadData(image: task.image, member: task.executorName , task: task.taskName, point: task.taskPoint, status: taskCellStatus.checkTask , doneTimes: 0)
            return checkCell
            
        case 2:
            let task = willDoTaskList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
            guard let willDoCell = cell as? TasksTableViewCell else { return cell}
            
            willDoCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: taskCellStatus.acceptSpecialTask, doneTimes: 0)
            
            return willDoCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
            return cell
        }
    }
    

}


extension LobbyViewController: UITableViewDelegate {

}


//enum taskCellStatus {
//    case checkTask
//    case acceptSpecialTask
//    case contribution
//    case doingTask
//    case doneTask
//    case assignNormalTask
//    case assignRegularTask
//}
