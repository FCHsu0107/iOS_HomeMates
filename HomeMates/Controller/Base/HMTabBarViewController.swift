//
//  STTabBarViewController.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

private enum Tab {

    case lobby

    case profile

    case task

    case statistics

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        case .task: controller = UIStoryboard.task.instantiateInitialViewController()!

        case .statistics: controller = UIStoryboard.statistics.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

        return controller
    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Home_24px),
                selectedImage: UIImage.asset(.Home_selected_24px)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Profile_24px),
                selectedImage: UIImage.asset(.Profile_selected_24px)
            )

        case .task:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Task_24px),
                selectedImage: UIImage.asset(.Task_selected_24px)
            )

        case .statistics:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Statistic_24px),
                selectedImage: UIImage.asset(.Statistic_selected_24px)
            )

        }
    }
}

class HMTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.lobby, .task, .statistics, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self

        StatusBarSettings.setBackgroundColor(color: UIColor.Y1)
    
        addNotificationObserver()
    }
    
    private func addNotificationObserver() {
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(refreshNewTask(noti:)),
            name: Notification.Name(NotificationName.didReceivePushNoti.rawValue), object: nil)
    }

    @objc func refreshNewTask(noti: Notification) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let tabBarController = delegate.window?.rootViewController as? HMTabBarViewController

        tabBarController?.selectedIndex = 0
    }
    
}
