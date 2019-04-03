//
//  TasksTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var memberNameText: UILabel!
    
    @IBOutlet weak var taskNameText: UILabel!
    
    @IBOutlet weak var pointText: UILabel!
    
    @IBOutlet weak var taskLeftBtn: UIButton!
    
    @IBOutlet weak var taskRightBtn: UIButton!
    
    @IBOutlet weak var taskPeriodText: UILabel!
    
    @IBOutlet weak var taskTotalPoints: UILabel!
    
    @IBOutlet weak var totalPointsText: UILabel!
    
    var taskObject: TaskObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func loadData(image: String, member: String, task: String, point: Int, status: TaskStatus, doneTimes: Int?) {
        
        taskImage.image = UIImage(named: image)
        switch status {
        case .checkTask:
            memberNameText.text = member
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("確認", for: .normal)

        case .acceptSpecialTask:

            memberNameText.text = member
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            
        case .contribution:
            memberNameText.text = member
            taskNameText.text = task
            pointText.isHidden = true
            taskRightBtn.isHidden = true
            
        case .doingTask:
            memberNameText.isHidden = true
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("完成", for: .normal)
            taskLeftBtn.setTitle("放棄", for: .normal)
            taskLeftBtn.isHidden = false
            
        case .doneTask:
            memberNameText.isHidden = true
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.isHidden = true
            
            totalPointsText.isHidden = false
            taskTotalPoints.isHidden = false
            
            guard let times = doneTimes else { return }
            taskTotalPoints.text = "\(point * times) 點"
            
        case .assignNormalTask:
            memberNameText.isHidden = true
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            
        case .assignRegularTask:
            memberNameText.isHidden = true
            taskNameText.text = task
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            taskPeriodText.text = "雙週任務"
            taskPeriodText.isHidden = false
        }
    }
    
}


enum TaskStatus {
    case checkTask
    case acceptSpecialTask
    case contribution
    case doingTask
    case doneTask
    case assignNormalTask
    case assignRegularTask
}
