//
//  AppDelegate+BDPGeoTriggeringEventDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Duncan Lau on 4/12/20.
//  Copyright © 2020 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK

extension AppDelegate: BDPGeoTriggeringEventDelegate {
    
    //MARK: This method is passed the Zone information utilised by the Bluedot SDK.
    func onZoneInfoUpdate(_ zoneInfos: Set<BDZoneInfo>) {
        print("zone information is received")
    }
    
    //MARK: Entered into a zone
    func didEnterZone(_ enterEvent: BDZoneEntryEvent) {
        print("You have checked into a zone")
        
        var formattedcheckInDate = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        
        formattedcheckInDate = dateFormatter.string(from: enterEvent.location.timestamp!)
        
        let message = "You have checked into fence '\((enterEvent.fence.name!))' in zone '\((enterEvent.zone().name!))', at \(formattedcheckInDate)"
        
        showAlert(title: "Application notification", message: message)

    }
    
    //MARK: Exit a Zone
    func didExitZone(_ exitEvent: BDZoneExitEvent) {
        print("checked out from a zone")
        
        let message = "You have left fence '\(exitEvent.fence.name!)' in zone '\(exitEvent.zone().name!)', after \(exitEvent.duration) minutes"
        showAlert(title: "Application notification", message: message)

    }
}
