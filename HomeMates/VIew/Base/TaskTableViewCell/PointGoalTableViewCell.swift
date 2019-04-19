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
    
    let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 6))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCornerRadius()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
 
    func showContributionView(member: String, memberImage: String, personalTotalPoints: Int, persent: Int) {
        memberImageView.image = UIImage(named: memberImage)
        userNameLbl.text = member
        totalPointsLbl.text = "累計積分： \(personalTotalPoints) 點"
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
