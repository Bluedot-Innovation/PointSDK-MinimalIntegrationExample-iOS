//
//  AppDelegate+BDPTempoTrackingDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Duncan Lau on 4/12/20.
//  Copyright © 2020 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK

extension AppDelegate: BDPTempoTrackingDelegate {
    
    func didStopTrackingWithError(_ error: Error!) {
        print("didStopTrackingWithError: \(error.localizedDescription)")
    }
    
    func tempoTrackingDidExpire() {
        print("tempoTrackingDidExpire")
    }
}
