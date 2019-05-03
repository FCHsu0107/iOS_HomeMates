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

    func taskTitle(tableView: UITableView, titleText: String) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.bounds.size.width,
                                              height: 60))
        
        headerView.backgroundColor = UIColor.white
        
        let labelBackgroundView = UIView(frame: CGRect(x: 20, y: 26, width: 100, height: 30))
        
        labelBackgroundView.backgroundColor = UIColor.Y1
        labelBackgroundView.layer.cornerRadius = 15
        
        let headerLabel = UILabel(frame: CGRect(x: 30,
                                                y: 32,
                                                width: 100,
                                                height: tableView.bounds.size.height))
        
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.text = titleText

        headerLabel.textAlignment = .center
        
        headerLabel.textColor = UIColor.Y4
        headerLabel.sizeToFit()
        
        headerView.addSubview(labelBackgroundView)
        headerView.addSubview(headerLabel)

//        let headerUnderline = UIView(frame: CGRect(x: 20,
//                                                   y: 39,
//                                                   width: tableView.bounds.size.width - 40,
//                                                   height: 0.8))
//
//        headerUnderline.backgroundColor = UIColor.B1
//        headerUnderline.sizeToFit()
//        headerView.addSubview(headerUnderline)
        
        return headerView
    }

}
