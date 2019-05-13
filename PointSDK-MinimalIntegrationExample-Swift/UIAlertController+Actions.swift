//
//  UserAlert.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Pavel Oborin on 26/11/18.
//  Copyright © 2018 Bluedot Innovation. All rights reserved.
//

import UIKit
import UserNotifications

extension UIAlertController {
    convenience init(title: String, message: String, style: UIAlertController.Style, actions: UIAlertAction...) {
        self.init(title: title, message: message, preferredStyle: style)
        actions.forEach{ self.addAction($0) }
    }
}
