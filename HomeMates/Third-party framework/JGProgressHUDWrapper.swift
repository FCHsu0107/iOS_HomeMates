//
//  JGProgressHUDWrapper.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/29.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import JGProgressHUD

enum HUDType {
    case success(String)
    case failure(String)
}

class HMProgressHUD {
    static let shared = HMProgressHUD()
    
    private init() {}
    
    let hud = JGProgressHUD(style: .dark)
    
    var view: UIView {
        return AppDelegate.shared.window!.rootViewController!.view
    }
    
    static func show(type: HUDType) {
        switch type {
        case .success(let text):
            showSuccess(text: text)
        case .failure(let text):
            showFailure(text: text)
        }
    }
    
    static func showSuccess(text: String = "載入成功") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            return
        }
        shared.hud.textLabel.text = text
        
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        shared.hud.show(in: shared.view, animated: true)
        
        shared.hud.dismiss(afterDelay: 1)
    }
    
    static func showFailure(text: String = "載入失敗") {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                showFailure(text: text)
            }
            return
        }
        shared.hud.textLabel.text = text
        
        shared.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        
        shared.hud.show(in: shared.view, animated: true)
        
        shared.hud.dismiss(afterDelay: 1)
    }
}
