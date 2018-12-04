//
//  AppDelegate+LocationDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Pavel Oborin on 26/11/18.
//  Copyright © 2018 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK

extension AppDelegate: BDPLocationDelegate {
    //MARK: This method is passed the Zone information utilised by the Bluedot SDK.
    func didUpdateZoneInfo(_ zoneInfos: Set<AnyHashable>) {
        print("zone information is received")
    }
    
    //MARK: checked into a zone
    //fence         - Fence triggered
    //zoneInfo      - Zone information Fence belongs to
    //location      - Geographical coordinate where trigger happened
    //customData    - Custom data associated with this Custom Action
    
    func didCheck(intoFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, atLocation location: BDLocationInfo!, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {
        print("You have checked into a zone")
        
        var formattedcheckInDate = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        formattedcheckInDate = dateFormatter.string(from: location.timestamp!)
        
        let message = "You have checked into fence '\((fence.name!))' in zone '\((zoneInfo.name!))', at \(formattedcheckInDate)"
        
        showAlert(title: "Application notification", message: message)
    }
    
    //MARK: Checked out from a zone
    //fence             - Fence user is checked out from
    //zoneInfo          - Zone information Fence belongs to
    //checkedInDuration - Time spent inside the Fence in minutes
    //customData        - Custom data associated with this Custom Action
    
    func didCheckOut( fromFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]! ) {
        print("checked out from a zone")
        
        let message = "You have left fence '\(fence.name!)' in zone '\(zoneInfo.name!)', after \(checkedInDuration) minutes"
        showAlert(title: "Application notification", message: message)
    }
    
    //MARK: A beacon with a Custom Action has been checked into; display an alert to notify the user.
    //beacon         - Beacon triggered
    //zoneInfo       - Zone information Beacon belongs to
    //locationInfo   - Geographical coordinate where trigger happened
    //proximity      - Proximity at which the trigger occurred
    //customData     - Custom data associated with this Custom Action
    
    func didCheck(intoBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, atLocation locationInfo: BDLocationInfo!, with proximity: CLProximity, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!) {
        print("You have checked into beacon \(beacon.name!) in zone \(zoneInfo.name!), at \(locationInfo.timestamp! )")
        
        var formattedcheckInDate = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        formattedcheckInDate = dateFormatter.string(from: locationInfo.timestamp!)
        
        let message = "You have checked into beacon '\(beacon.name!)' in zone '\(zoneInfo.name!)', at \( formattedcheckInDate)"
        showAlert(title: "Application notification", message: message)
    }
    
    //MARK: A beacon with a Custom Action has been checked out from; display an alert to notify the user.
    //beacon               - Beacon triggered
    //zoneInfo             - Zone information Beacon belongs to
    //checkedInDuration    - Time spent inside the Fence; in minutes
    //customData           - Custom data associated with this Custom Action
    //proximity            - Proximity at which the trigger occurred
    func didCheckOut(fromBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, with proximity: CLProximity, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]!) {
        print("You have checked out from beacon \(beacon.name!) in zone \(zoneInfo.name!), after \(checkedInDuration) minutes)")
        
        let message = "You have checked out from beacon '\(beacon.name!)' in zone '\(zoneInfo.name!)', after \(checkedInDuration) minutes"
        showAlert(title: "Application notification", message: message)
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Bluetooth is required by the SDK but is not enabled on the device; requiring user intervention.
    
    func didStartRequiringUserInterventionForBluetooth() {
        print("didStartRequiringUserInterventionForBluetooth called")
        
        self.window?.rootViewController?.present(userInterventionForBluetoothDialog, animated: true, completion: nil)
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Bluetooth and either user intervention has enabled Bluetooth or the Bluetooth service is no longer required.
    
    func didStopRequiringUserInterventionForBluetooth() {
        print("didStopRequiringUserInterventionForBluetooth called")
        userInterventionForBluetoothDialog.dismiss(animated: true, completion: nil)
    }
    
    //MARK:  This method is part of the Bluedot location delegate and is called when Location Services are not enabled on the device; requiring user intervention.
    func didStartRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus) {
        self.authorizationStatus = authorizationStatus
        
        switch authorizationStatus {
        case .denied:
            guard let controller = window?.rootViewController?.presentedViewController as? UIAlertController else {
                window?.rootViewController?.present(userInterventionForLocationServicesNeverDialog, animated: true)
                return
            }
            controller.dismiss(animated: true) {
                self.window?.rootViewController?.present(self.userInterventionForLocationServicesNeverDialog, animated: true)
            }
        case .authorizedWhenInUse:
            guard let controller = window?.rootViewController?.presentedViewController as? UIAlertController else {
                window?.rootViewController?.present(userInterventionForLocationServicesWhileInUseDialog, animated: true, completion: nil)
                return
            }
            controller.dismiss(animated: true) {
                self.window?.rootViewController?.present(self.userInterventionForLocationServicesWhileInUseDialog, animated: true, completion: nil);
            }
        default:
            return
        }
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Location Services and either Location Services has been enabled or the user is no longer within anauthenticated session, thereby no longer requiring Location Services.
    
    func didStopRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus) {
        guard let controller = window?.rootViewController?.presentedViewController as? UIAlertController else {
            return
        }

        controller.dismiss(animated: true, completion: nil)
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Low Power mode is enabled on the device; requiring user intervention to restore full SDK precision.
    
    func didStartRequiringUserInterventionForPowerMode() {
        window?.rootViewController?.present(userInterventionForPowerModeDialog, animated: true, completion: nil)
    }
    
    //MARK: if the user switches off 'Low Power mode', then didStopRequiringUserInterventionForPowerMode is called.
    
    func didStopRequiringUserInterventionForPowerMode() {
        userInterventionForPowerModeDialog.dismiss(animated: true, completion: nil)
    }
}
