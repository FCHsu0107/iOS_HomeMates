//
//  AddingTasksViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class AddingTasksViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: HMBaseTextField!
    
    @IBOutlet weak var taskPointsTextField: HMBaseTextField!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StatusBarSettings.setBackgroundColor(color: UIColor(red: 173/255, green: 144/255, blue: 38/255, alpha: 1))
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        StatusBarSettings.setBackgroundColor(color: UIColor.Y1)
    }
    
}
