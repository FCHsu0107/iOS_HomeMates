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
    
    let headerTitle = ["每日任務清單", "常規任務清單", "創立特殊任務"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: AddingTaskHeaderViewCell.self), bundle: nil)

    }

}

extension TaskSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddingTaskHeaderViewCell.self))
        guard let headerCell = cell as? AddingTaskHeaderViewCell else { return cell }
        headerCell.loadData(titleText: headerTitle[section])
        headerCell.taskTypeHandler = { [weak self] header in
            
            print(header)
            let indexPath = self?.tableView.indexPath(for: header)
            print(indexPath as Any)
            
        }
        return headerCell
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
