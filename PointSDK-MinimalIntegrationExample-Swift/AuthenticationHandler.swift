//
//  AuthenticationHandler.swift
//  PointSDK-MinimalIntegrationExample-iOS-Swift
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//
//

import Foundation
import BDPointSDK

class AuthenticationHandler {
    
    var locationManager : BDLocationManager!
    
    var apiKey : String
    var packageName : String
    var username : String
    
    init(apikey: String,packageName : String,username : String ){
        
        self.apiKey = apikey
        self.packageName = packageName
        self.username = username
        
        locationManager = BDLocationManager.instance()
        
    }
    
    func authenticate(){
        
        locationManager!.authenticate (
            withApiKey: apiKey
        )
        
    }
}

