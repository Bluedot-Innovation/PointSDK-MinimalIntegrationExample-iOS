//
//  OnboardingViewController.m
//  PointSDK-MinimalIntegrationExample-Objc
//
//  Created by Duncan Lau on 7/12/20.
//  Copyright © 2020 Bluedot Innovation. All rights reserved.
//

#import "OnboardingViewController.h"
@import BDPointSDK;

@interface OnboardingViewController ()

@end

@implementation OnboardingViewController

- (IBAction)allowLocationAccessTouchUpInside:(id)sender {
    [BDLocationManager.instance requestWhenInUseAuthorization];
}


@end
