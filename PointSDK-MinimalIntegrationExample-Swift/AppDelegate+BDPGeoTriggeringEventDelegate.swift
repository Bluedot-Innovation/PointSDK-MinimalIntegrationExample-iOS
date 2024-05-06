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
    
    //MARK: Called whenever new BDZoneInfo is received from Canvas
    func didUpdateZoneInfo() {
        print("Zone information is updated")
    }
    
    //MARK: Entered into a zone
    func didEnterZone(_ event: GeoTriggerEvent) {
        print("You have checked into a zone")
        
        var formattedcheckInDate = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        
        formattedcheckInDate = dateFormatter.string(from: event.entryEvent?.locations.first?.timestamp ?? Date())
        
        let message = "You have checked into fence '\(event.entryEvent?.fenceName ?? "")' in zone '\(event.zoneInfo.name)', at \(formattedcheckInDate)"
        
        showAlert(title: "Application notification", message: message)

    }
    
    //MARK: Exit a Zone
    func didExitZone(_ event: GeoTriggerEvent) {
        print("checked out from a zone")
        
        let message = "You have left fence '\(event.exitEvent?.fenceName ?? "")' in zone '\(event.zoneInfo.name)', after \(event.exitEvent!.dwellTime/1000/60) minutes"
        showAlert(title: "Application notification", message: message)

    }
}
