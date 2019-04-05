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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
