//
//  BlankTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/24.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class BlankTableViewCell: UITableViewCell {

    @IBOutlet weak var displayTextLbl: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadData(displayText: String) {
        displayTextLbl.text = displayText
    }
}
