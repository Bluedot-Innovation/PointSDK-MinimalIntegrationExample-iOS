//
//  AuthenticationHandler.h
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthenticationHandler : NSObject

@property NSString * apiKey;

-(id)initWithApiKey: (NSString *) apiKey;

-(void)authenticate;

@end
