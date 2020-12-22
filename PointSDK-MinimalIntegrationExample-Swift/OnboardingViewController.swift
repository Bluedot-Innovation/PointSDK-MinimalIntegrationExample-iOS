//
//  OnboardingViewController.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Duncan Lau on 3/12/20.
//  Copyright © 2020 Bluedot Innovation. All rights reserved.
//

import Foundation

import UIKit
import BDPointSDK
import UserNotifications

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func allowLocationAccess(_ sender: Any) {
        BDLocationManager.instance()?.requestAlwaysAuthorization()
    }
    
}
