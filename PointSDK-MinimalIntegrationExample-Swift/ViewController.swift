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
    // Use a project Id acquired from the Canvas UI.
    var projectId = "YourProjectId"
    
    // Use a Tempo Destination Id from the Canvas UI.
    var tempoDestinationId = "YourTempoDestinationId"
    
    @IBAction func initializeSDKButtonTouchUpInside(_ sender: Any) {
        //MARK: Initialize with Point SDK
        if BDLocationManager.instance()?.isInitialized() == false {
            BDLocationManager.instance()?.initialize(
                withProjectId: projectId){ error in
                guard error == nil else {
                    print("Initialisation Error: \(String(describing: error?.localizedDescription))")
                    self.showAlert(title: "Initialisation Error", message: error?.localizedDescription ?? "null")
                    return
                }
                
                print( "Initialised successfully with Point sdk" )
                BDLocationManager.instance()?.requestAlwaysAuthorization()
            }
        }
    }
    
    //MARK: Reset SDK
    @IBAction func resetButtonAction(_ sender: UIButton) {
        if BDLocationManager.instance()?.isInitialized() == true {
            BDLocationManager.instance()?.reset(){ error in
                guard error == nil else {
                    print("Reset Error \(String(describing: error?.localizedDescription)) ")
                    self.showAlert(title: "Reset Error", message: error?.localizedDescription ?? "null")
                    return
                }
                
                print( "Point SDK Reset successfully" )
            }
        }
    }
    
    //MARK: Start GeoTriggering
    @IBAction func startGeotriggeringTouchUpInside(_ sender: Any) {
        BDLocationManager.instance()?.startGeoTriggering(){ error in
            guard error == nil else {
                print("Start Geotriggering Error:  \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Start Geotriggering Error", message: error?.localizedDescription ?? "null")
                return
            }
            
            print( "Start Geotriggering successfully" )
        }
    }
    
    //MARK: Stop GeoTriggering
    @IBAction func stopGeotriggeringButtonTouchUpInside(_ sender: Any) {
        BDLocationManager.instance()?.stopGeoTriggering(){ error in
            guard error == nil else {
                print("Stop Geotriggering Error \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Stop Geotriggering Error", message: error?.localizedDescription ?? "null")
                return
            }
            
            print( "Stop Geotriggering successfully" )
        }
    }
    
    //MARK: Start Tempo
    @IBAction func startTempoButtonTouchUpInside(_ sender: Any) {
        BDLocationManager.instance()?.startTempoTracking(withDestinationId: tempoDestinationId){ error in
            guard error == nil else {
                print("Start Tempo Error: \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Start Tempo Error", message: error?.localizedDescription ?? "null")
                return
            }
            
            print( "Start Tempo successfully" )
        }
    }
    
    //MARK: Stop Tempo
    @IBAction func stopTempoButtonTouchUpInside(_ sender: Any) {
        BDLocationManager.instance()?.stopTempoTracking(){ error in
            guard error == nil else {
                print("Stop Tempo Error \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Stop Tempo Error", message: error?.localizedDescription ?? "null")
                return
            }
            
            print( "Stop Tempo successfully" )
        }
    }
    
    //MARK: Open Location settings on device
    @IBAction func openDeviceSettingsButtonTouchUpInside(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    
    private func showAlert(title: String,message: String) {
        //MARK:- Show Alert
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
