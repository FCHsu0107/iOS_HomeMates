//
//  ProfileHeaderViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileHeaderViewCell: UITableViewCell {

    @IBOutlet weak var profilePictureImage: UIImageView!

    @IBOutlet weak var memberNameTextLbl: UILabel!

    @IBOutlet weak var totalPointsTextLbl: UILabel!
    
    @IBOutlet weak var totalTimesTextLbl: UILabel!

    @IBOutlet weak var goalTextLbl: UILabel!

    @IBOutlet weak var infoFrameView: UIView!

    @IBOutlet weak var settingsBtn: UIButton!

    @IBOutlet weak var profileImageView: UIView!

    @IBOutlet weak var signoutBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCorner()
        
        memberNameTextLbl.text = UserDefaultManager.shared.userName

    }

    func setCorner() {
        infoFrameView.layer.cornerRadius = 10
        infoFrameView.layer.shadowOpacity = 0.1
        profilePictureImage.layer.cornerRadius = 40
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.shadowOpacity = 0.1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaultManager.shared.groupId = nil
        UserDefaultManager.shared.userUid = nil
        UserDefaultManager.shared.userName = nil
        try? Auth.auth().signOut()
        print("sign out")
    }
    
    func loadData(record: TaskRecord) {
        totalTimesTextLbl.text = String(record.totalTimes)
        totalPointsTextLbl.text = String(record.totalPoints)
        if record.goal == nil || record.goal == 0 {
            goalTextLbl.text = "--"
            return
        } else {
            guard let goal = record.goal else { return }
            let points = Double(record.totalPoints)

            let myGoal = Double(goal)
            let contribution = Int((points / myGoal) * 100)
            
            goalTextLbl.text = "\(contribution)%"
        }
    }
    
}
