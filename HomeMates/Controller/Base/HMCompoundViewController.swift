//
//  HMCompoundViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/5.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

//import UIKit
//
//class HMCompoundViewController:
//    HMBaseViewController,
//    UITableViewDelegate,
//    UITableViewDataSource
//{
//
//    @IBOutlet weak var tableView: UITableView!
//    
//    var taskListTitle: [String] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        cpdSetupTableView()
//        
//    }
//    
//    private func cpdSetupTableView(){
//        if tableView == nil {
//            let tableView = UITableView()
//            
//            view.stickSubView(tableView)
//            self.tableView = tableView
//        }
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return taskListTitle[section]
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Noto Sans Chakma Regular", size: 18)
//        header.textLabel?.textColor = UIColor.Y4
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch section {
//        case 0:
//            return CGFloat.leastNormalMagnitude
//        default:
//            return 40
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 4
//    }
//    
//    //MARK: - Tableview Setting
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         return UITableViewCell(style: .default, reuseIdentifier: String(describing: HMCompoundViewController.self))
//    }
//
//}
