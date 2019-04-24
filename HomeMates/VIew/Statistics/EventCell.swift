//
//  EventCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/6.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var doneEventTextLbl: UILabel!

    @IBOutlet weak var excutorNameTextLbl: UILabel!

    @IBOutlet weak var willdoEventTextLbl: UILabel!

    @IBOutlet weak var backgroundViewImage: UIView! {
        didSet {
            backgroundViewImage.layer.cornerRadius = 5
            backgroundViewImage.layer.shadowOpacity = 0.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func loadData(tasks: [TaskObject]) {
        if tasks.count == 0 {
            doneEventTextLbl.text = "無完成任務"
            excutorNameTextLbl.text = ""
        } else {
            var taskNames: [String] = []
            var excutorNames: [String] = []
            
            for task in tasks {
                let taskName = task.taskName
                guard let name = task.executorName else { return }
                taskNames.append(taskName)
                excutorNames.append(name)
            }
            
            let taskNameString = taskNames.joined(separator: "\n")
            let userNameString = excutorNames.joined(separator: "\n")
            doneEventTextLbl.text = taskNameString
            excutorNameTextLbl.text = userNameString
        }
        
    }
    
}
