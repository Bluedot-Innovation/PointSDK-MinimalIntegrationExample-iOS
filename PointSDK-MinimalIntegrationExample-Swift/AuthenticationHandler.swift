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
    
    init(apikey: String){
        
        self.apiKey = apikey
        
        locationManager = BDLocationManager.instance()
        
    }
    
    func authenticate(){
        
        locationManager!.authenticate (
            withApiKey: apiKey
        )
        
    }
}

