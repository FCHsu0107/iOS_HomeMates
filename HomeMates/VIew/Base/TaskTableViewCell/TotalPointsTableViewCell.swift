//
//  TotalPointsTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/19.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TotalPointsTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var taskNameLbl: UILabel!
    
    @IBOutlet weak var taskTimesLbl: UILabel!
    
    @IBOutlet weak var totalPointsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(tasksTracker: TaskRecord) {
        
        taskNameLbl.text = tasksTracker.taskName
        taskImage.image = UIImage(named: tasksTracker.taskImage ?? "home_normal")
        taskTimesLbl.text = "完成  \(String(tasksTracker.taskTimes)) 次"
        totalPointsLbl.text = "\(tasksTracker.taskPoint * tasksTracker.taskTimes) 點"
        
    }
}
