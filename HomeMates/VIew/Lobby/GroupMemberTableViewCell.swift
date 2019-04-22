//
//  GroupMemberTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/22.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class GroupMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImageView: UIImageView! {
        didSet {
            memberImageView.layer.cornerRadius = 27
        }
    }
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    var clickHandler: ((UITableViewCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadData(memberInfo: MemberObject) {
        userNameLbl.text = memberInfo.userName
        if memberInfo.permission == true {
            statusLbl.text = ""
            
        } else {
            statusLbl.text = "申請確認中"
        }
        editBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        
        clickHandler?(self)
    }
    
}
