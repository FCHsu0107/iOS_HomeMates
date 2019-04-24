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
    
    var pickerOptions: [String] = []
    
    var taskTrackerHandler: ((String) -> Void)?
    
    var taskList: [TaskObject] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func loadData(tasks: [TaskObject]) {
        var taskNames: [String] = []
        
        for task in tasks {
            let taskName = task.taskName
            taskNames.append(taskName)
        }
        pickerOptions = taskNames.removeDuplicates()
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
            selectTaskPicker.text = "無完成任務紀錄"
        } else {
            selectTaskPicker.text = pickerOptions[row]
            taskTrackerHandler?(pickerOptions[row])
        }
  
    }
}
