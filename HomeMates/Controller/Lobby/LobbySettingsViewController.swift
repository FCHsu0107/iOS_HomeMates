//
//  LobbySettingsViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/22.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class LobbySettingsViewController: HMBaseViewController {
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    @IBOutlet weak var groupIdLbl: UILabel!
    
    @IBOutlet weak var groupNameTextField: HMBaseTextField!
    
    @IBOutlet weak var editButton: UIButton!
    
    let memberHeader = TaskListHeaderView()
    
    var isSelected: Bool = false
    
    var actionSheet = UIAlertController()
    
    var memberList: [MemberObject] = [MemberObject(docId: nil,
                                                   userId: "A2g39Mxa0sMR3u0jtdv2IvgFwAu1",
                                                   userName: "Test01",
                                                   isCreator: false,
                                                   permission: true,
                                                   userPicture: "Profile_80px"),
                                      MemberObject(docId: nil,
                                                   userId: "sr5kfUXMgJbh2XeMTIicMaVEue52",
                                                   userName: "test02",
                                                   isCreator: false,
                                                   permission: false,
                                                   userPicture: "Profile_80px"),
                                      MemberObject(docId: nil,
                                                   userId: "ZxvDkvy5LuZv4rfeFV4iSWBsoz73",
                                                   userName: "UserTest00",
                                                   isCreator: true,
                                                   permission: true,
                                                   userPicture: "Profile_80px")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.jq_registerCellWithNib(identifier: String(describing: GroupMemberTableViewCell.self), bundle: nil)

    }

    @IBAction func clickEditBtn(_ sender: Any) {
        if editButton.isSelected == true {
            editButton.isSelected = false
            groupNameTextField.isEnabled = false
            isSelected = false
        } else {
            editButton.isSelected = true
            groupNameTextField.isEnabled = true
            groupNameTextField.becomeFirstResponder()
            isSelected = true
        }
    }
}

extension LobbySettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = memberHeader.taskTitle(tableView: tableView, titleText: "成員列表")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GroupMemberTableViewCell.self))
        guard let memberCell = cell as? GroupMemberTableViewCell else { return cell! }
        
        memberCell.loadData(memberInfo: memberList[indexPath.row])
        memberCell.clickHandler = { cell in
           guard let indexPath = tableView.indexPath(for: cell) else { return }
            let alertSheet = UIAlertController.showDeleteActionSheet(member: self.memberList[indexPath.row].userName,
                                                                     completion: { (flag) in
                if flag == true {
                    //delete member on the firestore
                }
            })
            self.present(alertSheet, animated: true, completion: nil)
            print(indexPath.row)
        }
        
        return memberCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
