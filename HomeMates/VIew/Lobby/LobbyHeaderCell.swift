//
//  LobbyHeaderCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/4.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbyHeaderCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!

    @IBOutlet weak var groupID: UILabel!

    @IBOutlet weak var lubbyBulletin: UILabel!

    @IBOutlet weak var groupImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.groupImage.layer.cornerRadius = 5
        self.groupImage.image = UIImage.asset(.home)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
