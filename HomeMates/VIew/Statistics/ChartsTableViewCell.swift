//
//  ChartsTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/9.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit
import Charts

class ChartsTableViewCell: UITableViewCell {

    @IBOutlet weak var chartView: PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
