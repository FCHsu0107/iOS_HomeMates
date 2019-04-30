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

    case more

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        case .task: controller = UIStoryboard.task.instantiateInitialViewController()!

        case .statistics: controller = UIStoryboard.statistics.instantiateInitialViewController()!

        case .more: controller = UIStoryboard.more.instantiateInitialViewController()!
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
                image: UIImage.asset(.home_normal),
                selectedImage: UIImage.asset(.home)
            )

        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.profile_normal),
                selectedImage: UIImage.asset(.profile)
            )

        case .task:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Task_24px),
                selectedImage: UIImage.asset(.Task_24px_normal)
            )

        case .statistics:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Statistic_24px_normal),
                selectedImage: UIImage.asset(.Statistic_24px)
            )

        case .more:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Idea_24px_normal),
                selectedImage: UIImage.asset(.Idea_24px)
            )
        }
    }
}

class HMTabBarViewController: UITabBarController, UITabBarControllerDelegate {

//    private let tabs: [Tab] = [.lobby, .profile, .task, .statistics, .more]
    private let tabs: [Tab] = [.lobby, .statistics, .task, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })

        delegate = self

        StatusBarSettings.setBackgroundColor(color: UIColor.Y1)
    }

}
