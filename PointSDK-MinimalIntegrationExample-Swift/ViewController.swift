//
//  ViewController.swift
//  PointSDK-MinimalIntegrationExample-iOS-Swift
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//
//

import UIKit
import BDPointSDK
import UserNotifications

class ViewController: UIViewController {
    //Add API key for the App
    var apiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Authenticate
        
        //Determine the authetication state
        switch BDLocationManager.instance()!.authenticationState {
        case .notAuthenticated:
            BDLocationManager.instance()?.authenticate(withApiKey: apiKey)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Stop SDK
    
    @IBAction func stopSDKBtnActn(_ sender: UIButton) {
        //Determine the authetication state
        switch BDLocationManager.instance()!.authenticationState {
        case .authenticated:
            BDLocationManager.instance()?.logOut()
            print("logged out from SDK")
        default:
            break
        }
    }
}
