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
    
    func sigleActionAlert(title: String, message: String?, clickTitle: String, vc: UIViewController) {
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let sigleAction = UIAlertAction(title: clickTitle, style:.default, handler: nil)
        
        controller.addAction(sigleAction)
        
        vc.present(controller, animated: true, completion: nil)
    }
    
}
