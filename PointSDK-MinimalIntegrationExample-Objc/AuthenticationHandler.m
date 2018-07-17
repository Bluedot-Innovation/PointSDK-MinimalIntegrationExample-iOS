//
//  AuthenticationHandler.m
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
@import BDPointSDK;

#import "AuthenticationHandler.h"

@interface AuthenticationHandler ()

@end

@implementation AuthenticationHandler

-(id)initWithUserName: (NSString *) userName andApiKey: (NSString *) apiKey andPackageName: (NSString *)packageName
{
    self = [super init];
    
    if (self)
    {
        self.apiKey = apiKey;
        self.userName = userName;
        self.packageName = packageName;
    }
    
    return self;
}


-(void)authenticate  {
    
    BDLocationManager  *locationManager = BDLocationManager.instance;
    
    if ( locationManager.authenticationState == BDAuthenticationStateNotAuthenticated )
    {
        [locationManager authenticateWithApiKey: _apiKey];
        
    }
    
}

@end



