//
//  TaskMakerTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/18.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TaskMakerTableViewCell: UITableViewCell
//, UIPickerViewDelegate, UIPickerViewDataSource
{
   
    @IBOutlet weak var selectPicker: HMBaseTextField!
//    private lazy var pickerView: UIPickerView = {
//    
//        let picker = UIPickerView()
//        
//        picker.dataSource = self
//        
//        picker.delegate = self
//        
//        return picker
//    }()
    
    var pickerOption: [String] = [] {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        <#code#>
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        <#code#>
//    }
    
}
