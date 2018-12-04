//
//  AppDelegate+BDPSessionDelegate.swift
//  PointSDK-MinimalIntegrationExample-Swift
//
//  Created by Pavel Oborin on 26/11/18.
//  Copyright © 2018 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK

extension AppDelegate: BDPSessionDelegate {
    func willAuthenticate(withApiKey: String!) {
        print( "Authenticating with Point sdk" )
    }
    
    func authenticationWasSuccessful() {
        print( "Authenticated successfully with Point sdk" )
    }
    
    func authenticationWasDenied(withReason reason: String!) {
        print("Authentication with Point sdk denied, with reason: \(reason)")
        showAlert(title: "Authentication Denied", message: reason)
    }
    
    func authenticationFailedWithError(_ error: Error!) {
        print( "Authentication with Point sdk failed, with reason: \(error.localizedDescription)" )
        
        guard let _ = error as? URLError else {
            showAlert(title: "Authentication Failed", message: error.localizedDescription)
            return
        }
        
        showAlert(title: "No data connection?", message: "Sorry, but there was a problem connecting to Bluedot servers.\n Please check you have a data connection, and that flight mode is disabled, then try again.")
    }
    
    func didEndSession() {
        print("Logged out")
    }
    
    func didEndSessionWithError( _ error: Error! ) {
        print("Logged out with error: \(error.localizedDescription)")
    }
}
