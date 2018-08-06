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
    
    var locationManager : BDLocationManager!
    var authenticationHandler : AuthenticationHandler!
    
    //Add API key for the App
    var apiKey : String = ""
    
    let dateFormatter = DateFormatter()
    
    var userInterventionForBluetoothDialog                  : UIAlertController?
    var userInterventionForLocationServicesNeverDialog      : UIAlertController?
    var userInterventionForLocationServicesWhileInUseDialog : UIAlertController?
    var userInterventionForPowerModeDialog                  : UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //MARK: Set BDLocationManager delegates
        locationManager = BDLocationManager.instance()
        locationManager?.locationDelegate = self
        locationManager?.sessionDelegate  = self
        
        //MARK: Authenticate
        authenticationHandler = AuthenticationHandler(apikey: apiKey)
        
        //Determine the authetication state
        switch locationManager!.authenticationState
        {
        case .notAuthenticated:
            authenticationHandler.authenticate()
            
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Stop SDK
    
    @IBAction func stopSDKBtnActn(_ sender: UIButton) {
        
        //Determine the authetication state
        switch locationManager!.authenticationState
        {
        case .authenticated:
            locationManager!.logOut()
            print("logged out from SDK")
            
        default:
            break
        }
        
    }
}

//MARK:- Conform to BDPSessionDelegate protocol - Point SDK's session related callbacks
extension ViewController : BDPSessionDelegate {
    
    func willAuthenticate(withApiKey: String!)
    {
        print( "Authenticating with Point sdk" )
    }
    
    func authenticationWasSuccessful()
    {
        print( "Authenticated successfully with Point sdk" )
    }
    
    func authenticationWasDenied( withReason reason: String! )
    {
        print("Authentication with Point sdk denied, with reason: \(reason)")
        showAlert(title: "Authentication Denied", message: reason)
        
    }
    
    func authenticationFailedWithError( _ error: Error! )
    {
        print( "Authentication with Point sdk failed, with reason: \(error.localizedDescription)" )
        
        let isConnectionError = ( ( (error as NSError).domain ) == NSURLErrorDomain )
        
        if ( isConnectionError )
        {
            showAlert(title: "No data connection?", message: "Sorry, but there was a problem connecting to Bluedot servers.\n Please check you have a data connection, and that flight mode is disabled, then try again.")
        }
        else
        {
            showAlert(title: "Authentication Failed", message: error.localizedDescription)
        }
        
    }
    
    func didEndSession()
    {
        print("Logged out")
        
    }
    
    func didEndSessionWithError( _ error: Error! )
    {
        print("Logged out with error: \(error.localizedDescription)")
        
    }
    
}

//MARK:- Conform to BDPLocationDelegate protocol - call-backs which Point SDK makes to inform the Application of location-related events

extension ViewController : BDPLocationDelegate {
    
    //MARK: This method is passed the Zone information utilised by the Bluedot SDK.
    func didUpdateZoneInfo( _ zoneInfos: Set<AnyHashable> )
    {
        print("zone information is received")
    }
    
    //MARK: checked into a zone
    //fence         - Fence triggered
    //zoneInfo      - Zone information Fence belongs to
    //location      - Geographical coordinate where trigger happened
    //customData    - Custom data associated with this Custom Action
    
    func didCheck(intoFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, atLocation location: BDLocationInfo!, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!)
    {
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
    
    func didCheckOut( fromFence fence: BDFenceInfo!, inZone zoneInfo: BDZoneInfo!, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]! )
    {
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
    
    func didCheck(intoBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, atLocation locationInfo: BDLocationInfo!, with proximity: CLProximity, willCheckOut: Bool, withCustomData customData: [AnyHashable : Any]!)
    {
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
    
    func didCheckOut( fromBeacon beacon: BDBeaconInfo!, inZone zoneInfo: BDZoneInfo!, with proximity: CLProximity, on date: Date!, withDuration checkedInDuration: UInt, withCustomData customData: [AnyHashable : Any]! )
    {
        print("You have checked out from beacon \(beacon.name!) in zone \(zoneInfo.name!), after \(checkedInDuration) minutes)")
        
        let message = "You have checked out from beacon '\(beacon.name!)' in zone '\(zoneInfo.name!)', after \(checkedInDuration) minutes"
        showAlert(title: "Application notification", message: message )
        
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Bluetooth is required by the SDK but is not enabled on the device; requiring user intervention.
    
    func didStartRequiringUserInterventionForBluetooth()
    {
        print("didStartRequiringUserInterventionForBluetooth called")
        
        if ( userInterventionForBluetoothDialog == nil )
        {
            let title = "Bluetooth Required"
            let message = "There are nearby Beacons which cannot be detected because Bluetooth is disabled.  Re-enable Bluetooth to restore full functionality."
            
            userInterventionForBluetoothDialog = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            userInterventionForBluetoothDialog?.addAction(dismiss)
        }
        
        self.present(userInterventionForBluetoothDialog!, animated: true, completion: nil)
        
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Bluetooth and either user intervention has enabled Bluetooth or the Bluetooth service is no longer required.
    
    func didStopRequiringUserInterventionForBluetooth()
    {
        print("didStopRequiringUserInterventionForBluetooth called")
        userInterventionForBluetoothDialog?.dismiss(animated: true, completion: nil)
    }
    
    //MARK:  This method is part of the Bluedot location delegate and is called when Location Services are not enabled on the device; requiring user intervention.
    
    func didStartRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus)
    {
        
        if( authorizationStatus == .denied)
        {
            let appName = Bundle.main.object( forInfoDictionaryKey: "CFBundleDisplayName" )
            let title = "Location Services Required"
            let message = "This App requires Location Services which are currently set to \(authorizationStatus == .authorizedWhenInUse ? "while in using" : "disabled").  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n\(String(describing: appName)) ✓"
            
            if ( userInterventionForLocationServicesNeverDialog == nil )
            {
                
                userInterventionForLocationServicesNeverDialog = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .alert
                )
            }
            
            if let currentPresentedViewController = self.presentedViewController
            {
                if(currentPresentedViewController.isKind(of: UIAlertController.self))
                {
                    currentPresentedViewController.dismiss(animated: true, completion: { [weak self] in
                        
                        if let weakSelf = self {
                            weakSelf.present(weakSelf.userInterventionForLocationServicesNeverDialog!, animated: true)
                        }
                        
                    })
                }
            }
            else
            {
                self.present(userInterventionForLocationServicesNeverDialog!, animated: true)
            }
            
        }
        else if(authorizationStatus == .authorizedWhenInUse)
        {
            if (userInterventionForLocationServicesWhileInUseDialog == nil) {
                let title = "Location Services set to 'While in Use'"
                let message = "You can ask for further location permission from user via this delegate method"
                
                userInterventionForLocationServicesWhileInUseDialog = UIAlertController(
                    title: title,
                    message:message,
                    preferredStyle:.alert
                )
                
                let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                
                userInterventionForLocationServicesWhileInUseDialog?.addAction(dismiss)
            }
            
            if let currentPresentedViewController = self.presentedViewController
            {
                if(currentPresentedViewController.isKind(of: UIAlertController.self))
                {
                    currentPresentedViewController.dismiss(animated: true, completion: { [weak self] in
                        
                        if let weakSelf = self {
                            weakSelf.present(weakSelf.userInterventionForLocationServicesWhileInUseDialog!, animated: true, completion: nil)
                        }
                        
                    })
                }
            }
            else
            {
                self.present(userInterventionForLocationServicesWhileInUseDialog!, animated: true, completion: nil);
            }
            
        }
        
    }
    
    //MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Location Services and either Location Services has been enabled or the user is no longer within anauthenticated session, thereby no longer requiring Location Services.
    
    func didStopRequiringUserIntervention(forLocationServicesAuthorizationStatus authorizationStatus: CLAuthorizationStatus)
    {
        if let currentPresentedViewController = self.presentedViewController {
            if (currentPresentedViewController.isKind(of: UIAlertController.self))
            {
                currentPresentedViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: This method is part of the Bluedot location delegate and is called when Low Power mode is enabled on the device; requiring user intervention to restore full SDK precision.
    
    func didStartRequiringUserInterventionForPowerMode()
    {
        if userInterventionForPowerModeDialog == nil
        {
            let title   = "Low Power Mode"
            let message = "Low Power Mode has been enabled on this device.  To restore full location precision, disable the setting at :\nSettings → Battery → Low Power Mode"
            
            userInterventionForPowerModeDialog = UIAlertController (
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let dismiss = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            userInterventionForPowerModeDialog?.addAction(dismiss)
        }
        
        self.present(userInterventionForPowerModeDialog!, animated: true, completion: nil)
    }
    
    //MARK: if the user switches off 'Low Power mode', then didStopRequiringUserInterventionForPowerMode is called.
    
    func didStopRequiringUserInterventionForPowerMode()
    {
        userInterventionForPowerModeDialog!.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController {
    //MARK:- Show Alert
    func showAlert(title: String,message: String){
        
        let applicationState = UIApplication.shared.applicationState
        
        switch applicationState
        {
        case .active: // In the fore-ground, display notification directly to the user
            
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let OK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(OK)
            
            present(alertController, animated: true, completion: nil)
            
        default:
            
            let content = UNMutableNotificationContent()
            content.title = "BDPoint notification"
            content.body = message
            content.sound = UNNotificationSound.default()
            
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



