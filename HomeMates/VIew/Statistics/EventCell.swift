//
//  EventCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var doneEventText: UILabel!

    @IBOutlet weak var excutorNameText: UILabel!

    @IBOutlet weak var willdoEventText: UILabel!

    @IBOutlet weak var backgroundViewImage: UIView! {
        didSet {
            backgroundViewImage.layer.cornerRadius = 5
            backgroundViewImage.layer.shadowOpacity = 0.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
