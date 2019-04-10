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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.groupImageView.layer.cornerRadius = 5
        self.groupImageView.image = UIImage.asset(.home)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
