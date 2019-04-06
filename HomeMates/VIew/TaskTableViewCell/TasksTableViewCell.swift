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
    
    @IBOutlet weak var firstTextContraint: NSLayoutConstraint!
    
    @IBOutlet weak var secondTextContraint: NSLayoutConstraint!
    
    var hiddenFirstText: Bool? {
        didSet {
            if hiddenFirstText == true {
                memberNameText.isHidden = true
                firstTextContraint.constant = 0
                secondTextContraint.constant = 8
            }
        }
    }

    
    var secondBtnAppear: Bool? {
        didSet {
            if secondBtnAppear == true {
                taskLeftBtn.isHidden = false
            }
        }
    }
    
    var showContribution: Bool? {
        didSet {
            if showContribution == true {
                pointText.isHidden = true
                taskRightBtn.isHidden = true
            }
        }
    }
    
    var taskObject: TaskObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    func loadData(image: String, member: String, task: String, point: Int, status: taskCellStatus, doneTimes: Int?, periodTime: Int? ) {
        
        taskImage.image = UIImage(named: image)
        taskNameText.text = task
        
        switch status {
        case .checkTask:

            memberNameText.text = "執行者：\(member)"
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("確認", for: .normal)

        case .acceptSpecialTask:

            memberNameText.text = "發佈人：\(member)"
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            
        case .contribution:
            showContribution = true
            memberNameText.text = member
            
        case .doingTask:
            hiddenFirstText = true
            secondBtnAppear = true
            
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("完成", for: .normal)
            taskLeftBtn.setTitle("放棄", for: .normal)
            
        case .doneTask:
            hiddenFirstText = true
           
            taskRightBtn.isHidden = true
            totalPointsText.isHidden = false
            taskTotalPoints.isHidden = false
            
            guard let times = doneTimes else { return }
            pointText.text = "完成 \(times) 次"
            taskTotalPoints.text = "\(point * times) 點"
            
        case .assignNormalTask:
            hiddenFirstText = true
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            
        case .assignRegularTask:
            hiddenFirstText = true
            
            pointText.text = "積分： \(point) 點"
            taskRightBtn.setTitle("接受", for: .normal)
            taskPeriodText.text = "雙週任務"
            taskPeriodText.isHidden = false
        }
    }
    
}


enum taskCellStatus {
    case checkTask
    case acceptSpecialTask
    case contribution
    case doingTask
    case doneTask
    case assignNormalTask
    case assignRegularTask
}
