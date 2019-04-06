//
//  ProfileHeaderViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProfileHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    @IBOutlet weak var memberNameText: UILabel!
    
    @IBOutlet weak var totalPointText: NSLayoutConstraint!
    
    @IBOutlet weak var totalTimesText: UILabel!
    
    @IBOutlet weak var contributionText: UILabel!
    
    @IBOutlet weak var infoFrameView: UIView!
    
    @IBOutlet weak var settingsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoFrameView.layer.cornerRadius = 10
        infoFrameView.layer.shadowOpacity = 0.1
        profilePictureImage.layer.cornerRadius = 30
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
