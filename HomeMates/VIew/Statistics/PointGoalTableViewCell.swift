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
        setCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    func showContributionView(memberInfo: MemberWithPoint) {
        
        memberImageView.image = UIImage(named: memberInfo.memberPicture)
        userNameLbl.text = memberInfo.memberName
        totalPointsLbl.text = "累計積分： \(memberInfo.point) 點"
        
        guard let goal = memberInfo.goal else {
            achievingRateView.isHidden = true
            noGoalLbl.isHidden = false
            return
        }
        let point = Double(memberInfo.point)
        let presentGoal = Double(goal)
        let persent = point / presentGoal * 100
        
            setProgress(CGFloat(persent))
    }
    
    private func setProgress(_ progress: CGFloat) {
        progressView.backgroundColor = UIColor.P1
        achievingRateView.addSubview(progressView)
        let fullWidth: CGFloat = achievingRateView.bounds.width
        let newWidth = progress / 100 * fullWidth
        
        UIView.animate(withDuration: 3) {
            self.progressView.frame.size = CGSize(width: newWidth, height: self.progressView.frame.height)
        }
    }
    
    private func setCornerRadius() {
        achievingRateView.layer.cornerRadius = 3
        progressView.layer.cornerRadius = 3
    }
}
