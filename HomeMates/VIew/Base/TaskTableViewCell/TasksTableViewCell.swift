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

    @IBOutlet weak var memberNameTextLbl: UILabel!

    @IBOutlet weak var taskNameTextLbl: UILabel!

    @IBOutlet weak var pointTextLbl: UILabel!

    @IBOutlet weak var taskLeftBtn: UIButton!

    @IBOutlet weak var taskRightBtn: UIButton!

    @IBOutlet weak var taskPeriodTextLbl: UILabel!

    @IBOutlet weak var firstTextConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondTextConstraint: NSLayoutConstraint!
    
    var clickHandler: ((UITableViewCell, Int) -> Void)?

    var hiddenFirstText: Bool = false {
        didSet {
            if hiddenFirstText == true {
                memberNameTextLbl.isHidden = true
                firstTextConstraint.constant = 0
                secondTextConstraint.constant = 0
            }
        }
    }

    var secondBtnAppear: Bool = false {
        didSet {
            if secondBtnAppear == true {
                taskLeftBtn.isHidden = false
            } else {
                taskLeftBtn.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadData(taskObject: TaskObject, status: TaskCellStatus) {

        taskImage.image = UIImage(named: taskObject.image)
        taskNameTextLbl.text = "任務：\(taskObject.taskName)"
        
        switch status {
        case .checkTask:
            secondBtnAppear = false
            guard let executor = taskObject.executorName else { return }
            guard let completionTimeStamp = taskObject.completionTimeStamp else { return }
            let completionDate = DateProvider.shared.getCurrentDate(currentTimeStamp: completionTimeStamp)
            pointTextLbl.text = "完成日期：\(completionDate)"
            taskNameTextLbl.text = "任務：\(taskObject.taskName)  積分：\(taskObject.taskPoint)點"
            memberNameTextLbl.text = "執行者：\(executor)"
            taskRightBtn.setTitle("確認", for: .normal)

        case .acceptSpecialTask:
            secondBtnAppear = false
            pointTextLbl.text = "積分： \(taskObject.taskPoint) 點"
            memberNameTextLbl.text = "發佈人：\(taskObject.publisherName)"
            taskRightBtn.setTitle("接受", for: .normal)

        case .ongingTask:
            hiddenFirstText = true
            secondBtnAppear = true
            taskRightBtn.isHidden = false
            pointTextLbl.text = "積分： \(taskObject.taskPoint) 點"
            taskRightBtn.setTitle("完成", for: .normal)
            taskLeftBtn.setTitle("放棄", for: .normal)
        }
        
        taskRightBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        taskLeftBtn.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        
    }

    @objc func clickBtnAction(_ sender: UIButton) {
        clickHandler?(self, sender.tag)
    }

}
