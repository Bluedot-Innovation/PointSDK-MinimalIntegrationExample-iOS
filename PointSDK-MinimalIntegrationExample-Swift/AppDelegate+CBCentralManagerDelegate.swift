//
//  AppDelegate+CBCentralManagerDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Pavel Oborin on 10/7/19.
//  Copyright © 2019 Bluedot Innovation. All rights reserved.
//

import Foundation
import CoreBluetooth

extension AppDelegate: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothEnabled = central.state == .poweredOn
    }
}
