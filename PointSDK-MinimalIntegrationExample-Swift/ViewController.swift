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
    
    @IBAction func initializeSDKButtonTouchUpInside(_ sender: Any) async {
        //MARK: Initialize with Point SDK
        guard BDLocationManager.instance()?.isInitialized() == false else {
            return
        }
        
        do {
            try await BDLocationManager.instance().initialize(withProjectId: projectId)
            print( "Initialised successfully with Point sdk" )
            BDLocationManager.instance()?.requestAlwaysAuthorization()
        } catch {
            print("Initialisation Error: \(error.localizedDescription)")
            self.showAlert(title: "Initialisation Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Reset SDK
    @IBAction func resetButtonAction(_ sender: UIButton) async {
        guard BDLocationManager.instance()?.isInitialized() == true else {
            return
        }
        
        do {
            try await BDLocationManager.instance()?.reset()
            print( "Point SDK Reset successfully" )
        }
        catch {
            print("Reset Error \(error.localizedDescription)")
            self.showAlert(title: "Reset Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Start GeoTriggering
    @IBAction func startGeotriggeringTouchUpInside(_ sender: Any) async {
        do {
            try await BDLocationManager.instance()?.startGeoTriggering()
            print( "Start Geotriggering successfully" )
        } catch {
            print("Start Geotriggering Error: \(error.localizedDescription)")
            self.showAlert(title: "Start Geotriggering Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Stop GeoTriggering
    @IBAction func stopGeotriggeringButtonTouchUpInside(_ sender: Any) async {
        do {
            try await BDLocationManager.instance()?.stopGeoTriggering()
            print( "Stop Geotriggering successfully" )
        } catch {
            print("Stop Geotriggering Error \(error.localizedDescription)")
            self.showAlert(title: "Stop Geotriggering Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Start Tempo
    @IBAction func startTempoButtonTouchUpInside(_ sender: Any) async {
        do {
            try await BDLocationManager.instance()?.startTempoTracking(withDestinationId: tempoDestinationId)
            print( "Start Tempo successfully" )
        } catch {
            print("Start Tempo Error: \(error.localizedDescription)")
            self.showAlert(title: "Start Tempo Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Stop Tempo
    @IBAction func stopTempoButtonTouchUpInside(_ sender: Any) async {
        do {
            try await BDLocationManager.instance()?.stopTempoTracking()
            print( "Stop Tempo successfully" )
        } catch {
            print("Stop Tempo Error \(error.localizedDescription)")
            self.showAlert(title: "Stop Tempo Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Open Location settings on device
    @IBAction func openDeviceSettingsButtonTouchUpInside(_ sender: Any) async {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        guard UIApplication.shared.canOpenURL(settingsUrl) else {
            return
        }
        
        let result = await UIApplication.shared.open(settingsUrl, options: [:])
        print("Settings opened: \(result)")
    }
    
    
    private func showAlert(title: String,message: String) {
        //MARK:- Show Alert
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: title, message: message, style: .alert, actions: dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
