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
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var taskListTitle: [String] = ["","完成任務", "任務清單"]
    var checkTaskList: [TaskObject] = [TaskObject(taskName: "拖地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal"), TaskObject(taskName: "掃地", publisherName: "System", executorName: "Daddy", taskPoint: 1, taskPriodDay: 1, image: "home_normal")]

    
    
    override var navigationBarIsHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell(style: .default, reuseIdentifier: String(describing: ProfileViewController.self))
    }
    
    
}
