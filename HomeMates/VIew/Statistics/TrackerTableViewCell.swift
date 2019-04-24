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
        print(pickerView)
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
        print(pickerOptions[row])
        
//        var taskDates: [String] = []
//        var userNames: [String] = []
//        for task in taskList {
//            if pickerOptions[row] == task.taskName {
//                guard let name = task.executorName, let date = task.completionDate else { return }
//                taskDates.append(date)
//                userNames.append(name)
//            } else {}
//        }
//        let taskDateString = taskDates.joined(separator: "\n")
//        let taskUserString = userNames.joined(separator: "\n")
//        print(taskDateString)
//        accomplishedDateTextLbl.text = taskDateString
//        excutorNameTextLbl.text = taskUserString
    }
}
