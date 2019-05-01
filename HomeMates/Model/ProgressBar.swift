//
//  ProgressBar.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/1.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import UIKit

class ProgressBar {
    func setProgress(_ progress: CGFloat, backgroundView: UIView, progressView: UIView) {
        backgroundView.layer.cornerRadius = 3
        progressView.layer.cornerRadius = 3
        progressView.backgroundColor = UIColor.P1
        backgroundView.addSubview(progressView)
        let fullWidth: CGFloat = backgroundView.bounds.width
        let newWidth = progress / 100 * fullWidth
        
//        UIView.animate(withDuration: 2) {
//            self.backgroundView.frame.size = CGSize(width: newWidth, height: self.progressView.frame.height)
//        }
    }
    
}
