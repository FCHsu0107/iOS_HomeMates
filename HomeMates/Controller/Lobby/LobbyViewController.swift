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
    
    var checkTaskList: [TaskObject] = [TaskObject(taskName: "拖地", publisherName: "System", executorName: "Mother", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal")]
    
    var willDoTaskList: [TaskObject] = [TaskObject(taskName: "打預防針", publisherName: "System", executorName: "", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal"), TaskObject(taskName: "清洗冷氣機濾網", publisherName: "System", executorName: "Daddyap", taskPoint: 2, taskPriodDay: 0, image: "home_normal")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.jq_registerCellWithNib(identifier: String(describing: TasksTableViewCell.self), bundle: nil)
    }
    


}


extension LobbyViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return checkTaskList.count
        case 1: return willDoTaskList.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TasksTableViewCell.self), for: indexPath)
        switch indexPath.section {
        case 0:
           let task = checkTaskList[indexPath.row]
            guard let checkCell = cell as? TasksTableViewCell else { return cell }

            checkCell.loadData(image: task.image, member: task.executorName , task: task.taskName, point: task.taskPoint, status: TaskStatus.checkTask , doneTimes: 0)
            return checkCell
            
        case 1:
            let task = willDoTaskList[indexPath.row]
            guard let willDoCell = cell as? TasksTableViewCell else { return cell}
            
            willDoCell.loadData(image: task.image, member: task.publisherName, task: task.taskName, point: task.taskPoint, status: TaskStatus.acceptSpecialTask, doneTimes: 0)
            
            return willDoCell
        default:
            return cell
        }
    }
    

}


extension LobbyViewController: UITableViewDelegate {

}


//enum TaskStatus {
//    case checkTask
//    case acceptSpecialTask
//    case contribution
//    case doingTask
//    case doneTask
//    case assignNormalTask
//    case assignRegularTask
//}
