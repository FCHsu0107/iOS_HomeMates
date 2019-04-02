//
//  UIStoryboard+Extension.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/4/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//
import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let lobby = "Lobby"
    
    static let profile = "Profile"
    
    static let task = "Task"
    
    static let statistics = "Statistics"
    
    static let more = "More"
    
    static let auth = "Auth"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var lobby: UIStoryboard { return stStoryboard(name: StoryboardCategory.lobby) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }
    
    static var task: UIStoryboard { return stStoryboard(name: StoryboardCategory.task) }
    
    static var statistics: UIStoryboard { return stStoryboard(name: StoryboardCategory.statistics) }
    
    static var more: UIStoryboard { return stStoryboard(name: StoryboardCategory.more)}
    
    static var auth: UIStoryboard { return stStoryboard(name: StoryboardCategory.auth) }
    
    private static func stStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
