//
//  TasksTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/3.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImage: UIImageView!
    
    @IBOutlet weak var memberNameText: UILabel!
    
    @IBOutlet weak var taskNameText: UILabel!
    
    @IBOutlet weak var pointText: UILabel!
    
    @IBOutlet weak var taskLeftBtn: UIButton!
    
    @IBOutlet weak var taskRightBtn: UIButton!
    
    @IBOutlet weak var taskPeriodText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
