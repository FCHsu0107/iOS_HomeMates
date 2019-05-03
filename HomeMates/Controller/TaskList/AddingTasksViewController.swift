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

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
