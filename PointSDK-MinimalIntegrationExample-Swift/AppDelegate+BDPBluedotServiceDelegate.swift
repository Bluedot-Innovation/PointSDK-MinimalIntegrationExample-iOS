//
//  AppDelegate+BDPBluedotServiceDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Duncan Lau on 4/12/20.
//  Copyright © 2020 Bluedot Innovation. All rights reserved.
//

import Foundation
@preconcurrency import BDPointSDK

extension AppDelegate: @preconcurrency BDPBluedotServiceDelegate {
    
    //MARK: Called when Device's low power mode status changed
    func lowPowerModeDidChange(_ isLowPowerMode: Bool) {
        if isLowPowerMode {
            window?.rootViewController?.present(lowPowerModeDialog, animated: true, completion: nil)
        } else {
            lowPowerModeDialog.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Called when location authorization status changed
    func locationAuthorizationDidChange(fromPreviousStatus previousAuthorizationStatus: CLAuthorizationStatus, toNewStatus newAuthorizationStatus: CLAuthorizationStatus) {
        
        self.authorizationStatus = newAuthorizationStatus
        
        switch authorizationStatus {
        case .denied:
            guard let _ = window?.rootViewController?.presentedViewController as? UIAlertController else {
                window?.rootViewController?.present(locationServicesNeverDialog, animated: true)
                return
            }
        case .authorizedWhenInUse:
            guard let _ = window?.rootViewController?.presentedViewController as? UIAlertController else {
                window?.rootViewController?.present(locationServicesWhileInUseDialog, animated: true, completion: nil)
                return
            }
        default:
            guard let controller = window?.rootViewController?.presentedViewController as? UIAlertController else {
                return
            }

            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: Called when location accuracy authorization status changed
    func accuracyAuthorizationDidChange(fromPreviousAuthorization previousAccuracyAuthorization: CLAccuracyAuthorization, toNewAuthorization newAccuracyAuthorization: CLAccuracyAuthorization) {
        
        switch newAccuracyAuthorization {
        case .reducedAccuracy:
            guard let _ = window?.rootViewController?.presentedViewController as? UIAlertController else {
                window?.rootViewController?.present(accuracyAuthorizationReducedDialog, animated: true)
                return
            }
        default:
            guard let controller = window?.rootViewController?.presentedViewController as? UIAlertController else {
                return
            }

            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func bluedotServiceDidReceiveError(_ error: Error!) {
        print("bluedotServiceDidReceiveError: \(error.localizedDescription)")
    }
}
