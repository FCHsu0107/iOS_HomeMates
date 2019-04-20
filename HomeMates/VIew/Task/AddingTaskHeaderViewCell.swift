//
//  AddingTaskHeaderViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/20.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class AddingTaskHeaderViewCell: UITableViewCell {

    @IBOutlet weak var titleNameLbl: UILabel!
    
    @IBOutlet weak var addingTaskBtn: UIButton! {
        didSet {
            addingTaskBtn.layer.cornerRadius = 5
        }
    }

    var taskTypeHandler: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadData(titleText: String) {
        titleNameLbl.text = titleText
        addingTaskBtn.addTarget(self, action: #selector(clickBtnAction), for: .touchUpInside)
    }
    
    @objc func clickBtnAction() {
        taskTypeHandler?(self)
    }
    
}
