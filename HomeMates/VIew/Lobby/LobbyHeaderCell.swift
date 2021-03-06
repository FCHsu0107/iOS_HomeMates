//
//  LobbyHeaderCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbyHeaderCell: UITableViewCell {

    @IBOutlet weak var groupNameLbl: UILabel!

    @IBOutlet weak var groupIDLbl: UILabel!

    @IBOutlet weak var lubbyBulletinLbl: UILabel!

    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBOutlet weak var settingsBtn: UIButton!
    var groupInfo: GroupObject? = nil {
        didSet {
            showGroupInfo()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.groupImageView.image = UIImage.asset(.HomeMates)
        showGroupInfo()
    }

    func showGroupInfo() {
        
        guard let groupInfo = groupInfo else {
            groupNameLbl.text = "資料載入中"
            groupIDLbl.text = "資料載入中"
            return }
        groupNameLbl.text = groupInfo.name
        groupIDLbl.text = "Home ID: \(String(describing: groupInfo.groupId))"
  
//        groupImageView.image = groupInfo?.picture
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
