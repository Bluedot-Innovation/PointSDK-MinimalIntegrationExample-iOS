//
//  AppDelegate.swift
//  PointSDK-MinimalIntegrationExample-iOS-Swift
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//
//

import UIKit
import UserNotifications
import CoreLocation
import BDPointSDK
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var centralManager: CBCentralManager?
    var isBluetoothEnabled = false
    
    let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
    
    lazy var userInterventionForBluetoothDialog: UIAlertController = {
        let title = "Bluetooth Required"
        let message = "There are nearby Beacons which cannot be detected because Bluetooth is disabled. Re-enable Bluetooth to restore full functionality."
        
        return UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
    }()
    
    lazy var userInterventionForLocationServicesNeverDialog: UIAlertController = {
        let appName = Bundle.main.object( forInfoDictionaryKey: "CFBundleDisplayName" )
        let title = "Location Services Required"
        let message = "This App requires Location Services which are currently set to \(authorizationStatus == .authorizedWhenInUse ? "while in using" : "disabled").  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n\(String(describing: appName)) ✓"
        
        return UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
    }()
    
    lazy var userInterventionForLocationServicesWhileInUseDialog: UIAlertController = {
        let title = "Location Services set to 'While in Use'"
        let message = "You can ask for further location permission from user via this delegate method"
        
        return UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
    }()
    
    lazy var userInterventionForPowerModeDialog: UIAlertController = {
        let title   = "Low Power Mode"
        let message = "Low Power Mode has been enabled on this device.  To restore full location precision, disable the setting at :\nSettings → Battery → Low Power Mode"
        
        return UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BDLocationManager.instance()?.sessionDelegate = self
        BDLocationManager.instance()?.locationDelegate = self
        centralManager = CBCentralManager(delegate: self,
                                          queue: nil,
                                          options: [CBCentralManagerOptionShowPowerAlertKey: NSNumber(booleanLiteral: false)])
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showAlert(title: String,message: String){
        //MARK:- Show Alert
        let applicationState = UIApplication.shared.applicationState
        
        switch applicationState
        {
        case .active: // In the fore-ground, display notification directly to the user
            let alertController = UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)

            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            
        default:
            
            let content = UNMutableNotificationContent()
            content.title = "BDPoint notification"
            content.body = message
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: "BDPointNotification", content: content, trigger: nil)
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().add(request) {(error) in
                if let error = error {
                    print("Notification error: \(error)")
                }
            }
        }
    }
}

