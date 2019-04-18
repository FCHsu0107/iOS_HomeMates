//
//  TrackerTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class TrackerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var selectTaskPicker: HMBaseTextField!
    
    @IBOutlet weak var accomplishedDateTextLbl: UILabel!
    
    @IBOutlet weak var excutorNameTextLbl: UILabel!
    
    private lazy var pickerView: UIPickerView = {
        
        let picker = UIPickerView()
        
        picker.delegate = self
        
        picker.dataSource = self
        
        return picker
    }()
    
    var pickerOptions = ["洗衣服", "洗碗", "準備早餐", "倒垃圾"]
    
    var taskTrackerHandler: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectTaskPicker.inputView = pickerView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectTaskPicker.text = pickerOptions[row]
        
        taskTrackerHandler?(pickerOptions[row])
    }
}
