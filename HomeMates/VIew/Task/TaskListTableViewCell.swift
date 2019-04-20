//
//  TaskListTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/20.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLbl: UILabel!
    
    @IBOutlet weak var taskPointLbl: UILabel!
    
    @IBOutlet weak var taskPriodLbl: UILabel!
    
    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var taskPriodTextheightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstTextXContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadData(task: TaskObject, isDaliyTask: Bool = true) {
        taskNameLbl.text = task.taskName
        taskPointLbl.text = "積分：\(task.taskPoint)"
        taskPriodLbl.text = "每 \(task.taskPriodDay) 天執行一次"
        taskImageView.image = UIImage(named: task.image)
        if isDaliyTask {
            taskPriodLbl.isHidden = true
            taskPriodTextheightContraint.constant = 0
            firstTextXContraint.constant = 20
        } else {
            taskPriodLbl.isHidden = false
            taskPriodTextheightContraint.constant = 18
            firstTextXContraint.constant = 12
        }
    }
}
