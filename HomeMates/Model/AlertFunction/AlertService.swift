//
//  AlertView.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    static func sigleActionAlert(title: String,
                                 message: String?,
                                 clickTitle: String,
                                 showInVc: UIViewController) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let sigleAction = UIAlertAction(title: clickTitle, style: .default, handler: nil)
        
        controller.addAction(sigleAction)
        
        showInVc.present(controller, animated: true, completion: nil)
    }

    static func addDailyTask(in presentVc: UIViewController, completion: @escaping (TaskObject) -> Void) {
        addTask(in: presentVc, taskPriodDay: 1, title: "新增每日任務", publisherName: "System") { (task) in
            completion(task)
        }
    }
    
    static func addSpecialTask(in presentVc: UIViewController, completion: @escaping (TaskObject) -> Void) {
        addTask(in: presentVc, taskPriodDay: 0,
                title: "新增特殊任務",
                publisherName: UserDefaultManager.shared.userName!) { (task) in
            completion(task)
        }
    }
    
     static func addTask(in presentVc: UIViewController,
                         taskPriodDay: Int,
                         title: String,
                         publisherName: String,
                         completion: @escaping (TaskObject) -> Void) {
        let alert = UIAlertController(title: title, message: "請填入任務名稱及積分", preferredStyle: .alert)
        alert.addTextField { (taskNameTF) in
            taskNameTF.placeholder = "任務名稱"
        }
        
        alert.addTextField { (taskPointTF) in
            taskPointTF.placeholder = "積分"
            taskPointTF.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "新增", style: .default) { (_) in
            guard
                let taskName = alert.textFields?.first?.text,
                let taskPointString = alert.textFields?.last?.text,
                let taskPoint = Int(taskPointString) else { return }
            
            let task = TaskObject(docId: nil,
                                  taskName: taskName,
                                  image: "Housework_48px",
                                  publisherName: publisherName,
                                  executorName: nil,
                                  executorUid: nil,
                                  taskPoint: taskPoint,
                                  taskPriodDay: taskPriodDay,
                                  compleyionTimeStamp: nil,
                                  taskStatus: 1)
            completion(task)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alert.addAction(cancel)
        alert.addAction(add)
        StatusBackgroundColor.statusBarForAlertView()
        presentVc.present(alert, animated: true)
    }
    
    static func addRegularTask(in presentVc: UIViewController, completion: @escaping (TaskObject) -> Void) {
        let alert = UIAlertController(title: "新增常規任務", message: "請填入任務名稱、積分及執行週期", preferredStyle: .alert)
        alert.addTextField { (taskNameTF) in
            taskNameTF.placeholder = "任務名稱"
        }
        
        alert.addTextField { (taskPointTF) in
            taskPointTF.placeholder = "積分"
            taskPointTF.keyboardType = .numberPad
        }
        
        alert.addTextField { (taskPriodDayTF) in
            taskPriodDayTF.placeholder = "每??天執行一次"
            taskPriodDayTF.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "新增", style: .default) { (_) in
            guard
                let taskName = alert.textFields?.first?.text,
                let taskPointString = alert.textFields?[1].text,
                let taskPoint = Int(taskPointString),
                let taskPriodDayString = alert.textFields?.last?.text,
                let taskPriodDay = Int(taskPriodDayString)
            else { return }
            
            let task = TaskObject(docId: nil,
                                  taskName: taskName,
                                  image: "Housework_48px",
                                  publisherName: "系統提醒",
                                  executorName: nil,
                                  executorUid: nil,
                                  taskPoint: taskPoint,
                                  taskPriodDay: taskPriodDay,
                                  compleyionTimeStamp: nil,
                                  taskStatus: 1)
            completion(task)
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alert.addAction(cancel)
        alert.addAction(add)
        StatusBackgroundColor.statusBarForAlertView()
        presentVc.present(alert, animated: true)
    }
}
