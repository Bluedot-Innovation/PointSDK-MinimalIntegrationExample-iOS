//
//  ViewController.m
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import "ViewController.h"
@import BDPointSDK;

@interface ViewController ()

@end

@implementation ViewController

//Add API key for the App
NSString  *apiKey = @"";

- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view, typically from a nib.
    
    //Determine the authentication state
    switch( BDLocationManager.instance.authenticationState )
    {
        case BDAuthenticationStateNotAuthenticated:
        {
            [BDLocationManager.instance authenticateWithApiKey: apiKey
                                          requestAuthorization: authorizedAlways];
            
            break;
        }
            
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

//MARK:- Stop SDK
- (IBAction)stopSDKBtnActn:(id)sender {
    
    //Determine the authentication state
    switch( BDLocationManager.instance.authenticationState )
    {
        case BDAuthenticationStateAuthenticated:
            [BDLocationManager.instance logOut];
            break;
            
        default:
            break;
    }
}

@end
