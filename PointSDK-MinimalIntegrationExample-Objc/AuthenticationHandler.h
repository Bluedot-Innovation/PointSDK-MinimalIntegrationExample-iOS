//
//  AuthenticationHandler.h
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationHandler : NSObject

@property NSString * userName;
@property NSString * apiKey;
@property NSString * packageName;

-(id)initWithUserName: (NSString *) userName andApiKey: (NSString *) apiKey andPackageName: (NSString *)packageName;

-(void)authenticate;

@end
