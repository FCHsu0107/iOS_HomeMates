//
//  PointGoalTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/19.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class PointGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var totalPointsLbl: UILabel!
    
    @IBOutlet weak var achievingRateView: UIView!
    
    @IBOutlet weak var memberImageView: UIImageView!
    
    @IBOutlet weak var noGoalLbl: UILabel!
    
    let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 6))
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    func showContributionView(memberInfo: MemberWithPoint) {
        
        userNameLbl.text = memberInfo.memberName
        totalPointsLbl.text = "累計積分： \(memberInfo.point) 點"
        
        guard let goal = memberInfo.goal else {
            achievingRateView.isHidden = true
            noGoalLbl.isHidden = false
            return
        }
        let point = Double(memberInfo.point)
        let presentGoal = Double(goal)
        var persent = point / presentGoal * 100
        if persent > 100 {
            persent = 100
        }
            setProgress(CGFloat(persent))
    }
    
    private func setProgress(_ progress: CGFloat) {
        achievingRateView.layer.cornerRadius = 3
        progressView.layer.cornerRadius = 3
        progressView.backgroundColor = UIColor.P1
        achievingRateView.addSubview(progressView)
        let fullWidth: CGFloat = achievingRateView.frame.width
        let newWidth = progress / 100 * fullWidth
        
        UIView.animate(withDuration: 2) {
            self.progressView.frame.size = CGSize(width: newWidth, height: self.progressView.frame.height)
        }
    }
    
}
