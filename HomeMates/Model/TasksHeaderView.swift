//
//  TasksHeaderView.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/8.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//
import Foundation
import UIKit

class TaskListHeaderView {
//    private init() {
//        
//    }
//    let shared = TaskListHeaderView()
    
    
    func taskTitle(tableView: UITableView, titleText: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 40))
        headerView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 12, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Noto Sans Chakma Regular", size: 15)
        headerLabel.text = titleText
        headerLabel.textColor = UIColor.Y4
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        let headerUnderline = UIView(frame: CGRect(x: 20, y: 39, width:tableView.bounds.size.width - 40 , height: 1))
        headerUnderline.backgroundColor = UIColor.B1
        headerUnderline.sizeToFit()
        headerView.addSubview(headerUnderline)
        
        return headerView
    }
    
}
