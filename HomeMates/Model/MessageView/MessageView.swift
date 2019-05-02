//
//  MessageView.swift
//  HomeMates
//
//  Created by Fu-Chiung HSU on 2019/5/2.
//  Copyright © 2019 Fu-Chiung HSU. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class MessagesViewProvider {
    func showSuccessView(title: String, body: String) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.isHidden = true
        SwiftMessages.show(view: view)
    }
}
