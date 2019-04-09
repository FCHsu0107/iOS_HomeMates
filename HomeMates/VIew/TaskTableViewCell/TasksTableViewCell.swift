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

    @IBOutlet weak var contributionPersentView: UIView!
    
    let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 6))

    var showContributionPersent: Bool? {
        didSet {
            if showContributionPersent == true {

                contributionPersentView.isHidden = false
                progressView.backgroundColor = UIColor.P1
                contributionPersentView.addSubview(progressView)
                pointText.isHidden = true
                taskRightBtn.isHidden = true
            }
        }
    }

    var hiddenFirstText: Bool? {
        didSet {
            if hiddenFirstText == true {
                memberNameText.isHidden = true
                firstTextContraint.constant = 0
                secondTextContraint.constant = 0
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

    var showPersonalPoints: Bool? {
        didSet {
            if showPersonalPoints == true {
                pointText.isHidden = false
                totalPointsText.isHidden = false
                taskTotalPoints.isHidden = false
                taskRightBtn.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        btnCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    private func btnCornerRadius() {
        taskRightBtn.layer.cornerRadius = 5
        taskLeftBtn.layer.cornerRadius = 5
        contributionPersentView.layer.cornerRadius = 5
        progressView.layer.cornerRadius = 5
    }

    func loadData(taskObject: TaskObject, status: TaskCellStatus) {

        taskImage.image = UIImage(named: taskObject.image)
        taskNameText.text = "任務：\(taskObject.taskName)"
        pointText.text = "積分： \(taskObject.taskPoint) 點"

        switch status {
        case .checkTask:

            guard let executor = taskObject.executorName else { return }
            memberNameText.text = "執行者：\(executor)"
            taskRightBtn.setTitle("確認", for: .normal)

        case .acceptSpecialTask:

            memberNameText.text = "發佈人：\(taskObject.publisherName)"
            taskRightBtn.setTitle("接受", for: .normal)

        case .doingTask:
            hiddenFirstText = true
            secondBtnAppear = true

            taskRightBtn.setTitle("完成", for: .normal)
            taskLeftBtn.setTitle("放棄", for: .normal)

        case .assignNormalTask:
            hiddenFirstText = true
            taskRightBtn.setTitle("接受", for: .normal)

        case .assignRegularTask:
            hiddenFirstText = true

            taskRightBtn.setTitle("接受", for: .normal)
            taskPeriodText.isHidden = false
            taskPeriodText.text = "雙週任務"
        }
    }

    func showContributionView(member: String, memberImage: String, personalTotalPoints: Int, persent: Int) {
        showContributionPersent = true
        taskImage.image = UIImage(named: memberImage)
        memberNameText.text = member
        taskNameText.text = "累計積分： \(personalTotalPoints) 點"
        setProgress(CGFloat(persent))
    }

    private func setProgress(_ progress: CGFloat) {
        let fullWidth: CGFloat = contributionPersentView.bounds.width
        let newWidth = progress / 100 * fullWidth
        UIView.animate(withDuration: 3) {
            self.progressView.frame.size = CGSize(width: newWidth, height: self.progressView.frame.height)
        }
    }

    func personalTaskSum(taskName: String, image: String, taskTimes: Int, point: Int) {
        hiddenFirstText = true
        showPersonalPoints = true
        taskNameText.text = taskName
        taskImage.image = UIImage(named: image)
        pointText.text = "完成 \(taskTimes) 次"
        taskTotalPoints.text = "\(taskTimes * point) 點"

    }

}

