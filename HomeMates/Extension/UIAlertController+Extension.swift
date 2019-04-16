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
                               completion: @escaping (_ index: Int)-> Void ) -> UIAlertController {
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
}
// viewController.present(alertViewController, animated: true, completion: nil)
