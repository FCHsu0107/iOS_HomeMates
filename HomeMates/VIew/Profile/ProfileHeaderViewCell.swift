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

    @IBOutlet weak var memberNameTextLbl: UILabel!

    @IBOutlet weak var totalPointTextConstraint: NSLayoutConstraint!

    @IBOutlet weak var totalTimesTextLbl: UILabel!

    @IBOutlet weak var contributionTextLbl: UILabel!

    @IBOutlet weak var infoFrameView: UIView!

    @IBOutlet weak var settingsBtn: UIButton!

    @IBOutlet weak var profileImageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        infoFrameView.layer.cornerRadius = 10
        infoFrameView.layer.shadowOpacity = 0.1
        profilePictureImage.layer.cornerRadius = 40
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.shadowOpacity = 0.1

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
