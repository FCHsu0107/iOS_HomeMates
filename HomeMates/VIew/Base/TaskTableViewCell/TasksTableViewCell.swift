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

    @IBOutlet weak var taskTotalPointsLbl: UILabel!

    @IBOutlet weak var totalPointsTextLbl: UILabel!

    @IBOutlet weak var firstTextConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondTextConstraint: NSLayoutConstraint!

    @IBOutlet weak var contributionPersentView: UIView!
    
    let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 6))

    var showContributionPersent: Bool? {
        didSet {
            if showContributionPersent == true {

                contributionPersentView.isHidden = false
                progressView.backgroundColor = UIColor.P1
                contributionPersentView.addSubview(progressView)
                pointTextLbl.isHidden = true
                taskRightBtn.isHidden = true
            }
        }
    }

    var hiddenFirstText: Bool? {
        didSet {
            if hiddenFirstText == true {
                memberNameTextLbl.isHidden = true
                firstTextConstraint.constant = 0
                secondTextConstraint.constant = 0
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
                pointTextLbl.isHidden = false
                totalPointsTextLbl.isHidden = false
                taskTotalPointsLbl.isHidden = false
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
        taskNameTextLbl.text = "任務：\(taskObject.taskName)"
        pointTextLbl.text = "積分： \(taskObject.taskPoint) 點"

        switch status {
        case .checkTask:

            guard let executor = taskObject.executorName else { return }
            memberNameTextLbl.text = "執行者：\(executor)"
            taskRightBtn.setTitle("確認", for: .normal)

        case .acceptSpecialTask:

            memberNameTextLbl.text = "發佈人：\(taskObject.publisherName)"
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
//            taskPeriodTextLbl.isHidden = false
//            taskPeriodTextLbl.text = "雙週任務"
        }
    }

    func showContributionView(member: String, memberImage: String, personalTotalPoints: Int, persent: Int) {
        showContributionPersent = true
        taskImage.image = UIImage(named: memberImage)
        memberNameTextLbl.text = member
        taskNameTextLbl.text = "累計積分： \(personalTotalPoints) 點"
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
        taskNameTextLbl.text = taskName
        taskImage.image = UIImage(named: image)
        pointTextLbl.text = "完成 \(taskTimes) 次"
        taskTotalPointsLbl.text = "\(taskTimes * point) 點"

    }
}
