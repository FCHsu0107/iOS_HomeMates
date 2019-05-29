//
//  HMBaseTextField.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class HMBaseTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 4, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.insetBy(dx: 4, dy: 0)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 4, dy: 0)
    }
    
}

class NoEditTextField: HMBaseTextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
