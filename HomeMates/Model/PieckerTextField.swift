//
//  PieckerTextField.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/18.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class PickerTextField: HMBaseTextField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        
        picker.dataSource = self
        
        return picker
    }()
    
    var pieckerOptions: [String] = [] 
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pieckerOptions.count
    }
    
}
