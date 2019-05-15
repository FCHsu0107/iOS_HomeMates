//
//  UIAlertController+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/16.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func sigleActionAlert(title: String,
                                 message: String?,
                                 clickTitle: String) -> UIAlertController {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let sigleAction = UIAlertAction(title: clickTitle, style: .default, handler: nil)
        
        controller.addAction(sigleAction)
        
        return controller
    }
    
    static func showAlertSheet(title: String?,
                               message: String?,
                               action: [(String)],
                               completion: @escaping (_ index: Int) -> Void) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for (index, (title)) in action.enumerated() {
            let alertAction = UIAlertAction(title: title, style: .default) { (_) in
                completion(index)
            }
            alertViewController.addAction(alertAction)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alertViewController.addAction(cancelAction)
        return alertViewController
    }
    
    static func showDeleteActionSheet(member: String, completion: @escaping (Bool) -> Void) -> UIAlertController {
        let alertViewController = UIAlertController(title: "移除成員",
                                                    message: "點擊確認移除鍵即將成員\(member)移除群組，過往相關記錄將會全部移除，無法復原",
            preferredStyle: .actionSheet)
        
        let alertAction = UIAlertAction(title: "確認移除成員 \(member)", style: .destructive) { (_) in
            completion(true)
        }
        alertViewController.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alertViewController.addAction(cancelAction)
        return alertViewController
    }
    
    static func dropOutGroupActionSheet(
        memberNumber: Int, completion: @escaping (Bool) -> Void) -> UIAlertController {
        var message: String = ""
        if memberNumber == 1 {
            message = "退出群組後，所屬群組將無任何成員，所屬群組的過往紀錄將會全部刪除，無法復原。"
        } else {
             message =  "點擊確確認退出所屬群組，與群組相關的記錄將會全部移除，無法復原。"
        }
        
        let alertViewController = UIAlertController(
            title: "退出所屬群組",  message: message, preferredStyle: .actionSheet)
        
        let alertAction = UIAlertAction(title: "確認退出所屬群組", style: .destructive) { (_) in
            completion(true)
        }
        
        alertViewController.addAction(alertAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alertViewController.addAction(cancelAction)
        return alertViewController
    }
    
    private func singleOptionAlterSheet(
        title: String, message: String, optionTitle: String,
        completion: @escaping (Bool) -> Void)  -> UIAlertController {
        
        let alertViewController = UIAlertController(
            title: title,  message: message, preferredStyle: .actionSheet)
        
        let alertAction = UIAlertAction(title: optionTitle, style: .destructive) { (_) in
            completion(true)
        }
        alertViewController.addAction(alertAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ -> Void in }
        alertViewController.addAction(cancelAction)
        
        return alertViewController
    }
}
// viewController.present(alertViewController, animated: true, completion: nil)
