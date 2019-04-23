//
//  UIAlertController+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/16.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

extension UIAlertController {

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
    
}
// viewController.present(alertViewController, animated: true, completion: nil)
