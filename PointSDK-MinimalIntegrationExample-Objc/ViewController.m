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

// Use a project Id acquired from the Canvas UI.
NSString *projectId = @"YourProjectId";

// Use a Tempo Destination Id from the Canvas UI.
NSString * tempoDestinationId = @"YourTempoDestinationId";


- (IBAction)initializeSDkTouchUpInside {
    //MARK: Initialize with Point SDK
    if([BDLocationManager.instance isInitialized] == NO)
    {
        [BDLocationManager.instance initializeWithProjectId:projectId completion:^(NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Initialisation Error: %@", error.localizedDescription);
                [self showAlertWithTitle:@"Initialisation Error" message:error.localizedDescription];
                return;
            }
            
            NSLog(@"Initialised successfully with Point sdk");
        }];

    }
}

- (IBAction)resetSDkTouchUpInside {
    if([BDLocationManager.instance isInitialized] == YES)
    {
        [BDLocationManager.instance resetWithCompletion:^(NSError * _Nullable error) {
            if(error != nil){
                NSLog(@"Reset Error: %@", error.localizedDescription);
                [self showAlertWithTitle:@"Reset Error" message:error.localizedDescription];
                return;
            }
            
            NSLog(@"Point SDK Reset successfully");
        }];

    }
}

- (IBAction)startGeotriggeringTouchUpInside {
    [BDLocationManager.instance startGeoTriggeringWithCompletion:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Start Geotriggering Error: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Start Geotriggering Error" message:error.localizedDescription];
            return;
        }
        
        NSLog(@"Start Geotriggering successfully");
    }];
}

- (IBAction)stopGeotriggeringTouchUpInside {
    [BDLocationManager.instance stopGeoTriggeringWithCompletion:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Stop Geotriggering Error: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Stop Geotriggering Error" message:error.localizedDescription];
            return;
        }
        
        NSLog(@"Stop Geotriggering successfully");
    }];
}

- (IBAction)startTempoTouchUpInside {
    [BDLocationManager.instance startTempoTrackingWithDestinationId:tempoDestinationId completion:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Start Tempo Error: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Start Tempo Error" message:error.localizedDescription];
            return;
        }
        
        NSLog(@"Start Tempo successfully");
    }];
}

- (IBAction)stopTempoTouchUpInside {
    [BDLocationManager.instance stopTempoTrackingWithCompletion:^(NSError * _Nullable error) {
        if(error != nil) {
            NSLog(@"Stop Tempo Error: %@", error.localizedDescription);
            [self showAlertWithTitle:@"Stop Tempo Error" message:error.localizedDescription];
            return;
        }
        
        NSLog(@"Stop Tempo successfully");
    }];
}

- (IBAction)openLocationSettingsTouchUpInside {
    
    NSURL * settingsUrl = [[NSURL alloc] initWithString: UIApplicationOpenSettingsURLString];
    
    if(settingsUrl == nil) {
        return;
    }
    
    if([UIApplication.sharedApplication canOpenURL:settingsUrl])
    {
        [UIApplication.sharedApplication openURL:settingsUrl options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Settings Opened: %@", success ? @"Yes" : @"No");
        }];
    }
}

- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message
{
    UIAlertController *alertController = [ UIAlertController alertControllerWithTitle: title
                         message: message
                  preferredStyle: UIAlertControllerStyleAlert ];
            
    UIAlertAction *OK = [ UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil ];
            
    [ alertController addAction:OK ];
            
    [self presentViewController: alertController animated: YES completion: nil];
}

@end
