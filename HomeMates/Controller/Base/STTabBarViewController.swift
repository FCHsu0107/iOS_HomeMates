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
                image: UIImage.asset(.profile_normal),
                selectedImage: UIImage.asset(.profile)
            )
            
        case .statistics:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.profile_normal),
                selectedImage: UIImage.asset(.profile)
            )
            
        case .more:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.profile_normal),
                selectedImage: UIImage.asset(.profile)
            )
        }
    }
}

class STTabBarViewController: UITabBarController, UITabBarControllerDelegate {

    private let tabs: [Tab] = [.lobby, .profile, .task, .statistics, .more]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = tabs.map({ $0.controller() })
        
        delegate = self
    }
    
    //MARK: - UITabBarControllerDelegate
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    
//        guard let navVC = viewController as? UINavigationController,
//            let _ = navVC.viewControllers.first as? ProfileViewController
//            else { return true }
        
//        guard KeyChainManager.shared.token != nil else {
//
//            if let vc = UIStoryboard.auth.instantiateInitialViewController() {
//
//                vc.modalPresentationStyle = .overCurrentContext
//
//                present(vc, animated: false, completion: nil)
//            }
//
//            return false
//        }
//
//        return true
//    }
    

}
