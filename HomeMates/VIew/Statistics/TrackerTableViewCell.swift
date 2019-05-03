//
//  TrackerTableViewCell.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/10.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

protocol SelectDoneTaskDelegate: AnyObject {
    
    func doneBtnDidClick()
}

class TrackerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var selectTaskTextField: HMBaseTextField!
    
    @IBOutlet weak var accomplishedDateTextLbl: UILabel!
    
    @IBOutlet weak var excutorNameTextLbl: UILabel!
    
    private lazy var pickerView: UIPickerView = {
        
        let picker = UIPickerView()
        
        picker.delegate = self
        
        picker.dataSource = self
        
        return picker
    }()
    
    var pickerOptions: [String] = []
    
    var taskTrackerHandler: ((String) -> Void)?
    
    var taskList: [TaskObject] = []
    
    weak var delegate: SelectDoneTaskDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectTaskTextField.delegate = self
    }

    func loadData(tasks: [TaskObject]) {
        var taskNames: [String] = []
        
        for task in tasks {
            let taskName = task.taskName
            taskNames.append(taskName)
        }
        pickerOptions = taskNames.removeDuplicates()
        selectTaskTextField.inputView = pickerView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerOptions.count == 0 {
            return 1
        } else {
            return pickerOptions.count
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerOptions.count == 0 {
            return "無完成任務紀錄"
        } else {
            return pickerOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerOptions.count == 0 {
            selectTaskTextField.text = "無完成任務紀錄"
        } else {
            selectTaskTextField.text = pickerOptions[row]
            taskTrackerHandler?(pickerOptions[row])
        }
  
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.doneBtnDidClick()
    }
    
}
