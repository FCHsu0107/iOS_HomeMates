//
//  AddingTasksViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class AddingTasksViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var taskNameTextField: HMBaseTextField!
    
    @IBOutlet weak var taskPointsTextField: HMBaseTextField! 
    
    @IBOutlet weak var dailyTaskBtn: UIButton!
    
    let messageView = MessagesView()
    
    let sender = PushNotificationSender()
    
    var membersInfo: [MemberObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        readGroupInfo()
        taskNameTextField.delegate = self
    }
    
    private func setUpView() {
        StatusBarSettings.setBackgroundColor(color: UIColor(red: 173/255, green: 144/255, blue: 38/255, alpha: 1))

    }
    
    private func readGroupInfo() {
        FirestoreGroupManager.shared.readGroupMembers { [weak self] (members) in
            self?.membersInfo = members
        }
    }
    
    @IBAction func selectedDaliyTask(_ sender: Any) {
        if dailyTaskBtn.isSelected == true {
            dailyTaskBtn.isSelected = false
        } else {
            dailyTaskBtn.isSelected = true
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        StatusBarSettings.setBackgroundColor(color: UIColor.Y1)
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        
        if taskNameTextField.text?.isEmpty == true || taskPointsTextField.text?.isEmpty == true {
            let alert = UIAlertController.sigleActionAlert(title: "提醒", message: "請輸入名稱及積分", clickTitle: "收到")
            self.present(alert, animated: false, completion: nil)
        } else {
            guard let taskPoint = Int(taskPointsTextField.text!) else {
                return
            }
            if taskPoint > 10 {
                let alert = UIAlertController.sigleActionAlert(title: "提醒", message: "任務積分須小於 100", clickTitle: "收到")
                self.present(alert, animated: false, completion: nil)
            } else {
                addNewTask()
                
                dismiss(animated: false, completion: nil)
                StatusBarSettings.setBackgroundColor(color: UIColor.Y1)
            }
        }
    }
    
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        let maxLength = 6
        guard let text = textField.text else {
            return true
        }
            let currentString: NSString = text as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        
    }
    
    private func addNewTask() {
        guard
            let taskName = taskNameTextField.text,
            let taskPointString = taskPointsTextField.text,
            let taskPoint = Int(taskPointString)
            else { return }
        var task = TaskObject(docId: nil,
                              taskName: taskName,
                              image: "Housework_48px",
                              publisherName: UserDefaultManager.shared.userName!,
                              executorName: nil,
                              executorUid: nil,
                              taskPoint: taskPoint,
                              taskPriodDay: 1,
                              completionTimeStamp: nil,
                              completionDate: nil,
                              taskStatus: 1)
        if dailyTaskBtn.isSelected == true {
            FirestoreGroupManager.shared.addTask(for: task)
            FirestoreGroupManager.shared.addDailyTaskList(task: task)
            
        } else {
            task.taskPriodDay = 0
            FirestoreGroupManager.shared.addTask(for: task)
            
        }
        messageView.showSuccessView(title: "新增任務成功", body: "請至大廳接取任務")
        
        guard let userName = UserDefaultManager.shared.userName else { return }
        for member in membersInfo where member.userName != userName {
            if let memberToken = member.fcmToken {
                sender.sendPushNotification (
                    to: memberToken, title: "有一項新任務",
                    body: "\(userName) 發佈一項新任務\(taskName)，快來認大廳接任務吧！")
                
            }
        }
    }
}
