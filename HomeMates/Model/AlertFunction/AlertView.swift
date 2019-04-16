//
//  AlertView.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/11.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    static func sigleActionAlert(title: String,
                                 message: String?,
                                 clickTitle: String,
                                 showInVc: UIViewController) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let sigleAction = UIAlertAction(title: clickTitle, style: .default, handler: nil)
        
        controller.addAction(sigleAction)
        
        showInVc.present(controller, animated: true, completion: nil)
    }
//    
//    static func showActionsheet(viewController: UIViewController,
//                                title: String, message: String,
//                                actions: [(String, UIAlertAction.Style)],
//                                completion: @escaping (_ index: Int) -> Void) {
//        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//        for (index, (title, style)) in actions.enumerated() {
//            let alertAction = UIAlertAction(title: title, style: style) { (_) in
//                completion(index)
//            }
//            alertViewController.addAction(alertAction)
//        }
//        viewController.present(alertViewController, animated: true, completion: nil)
//    }

}
