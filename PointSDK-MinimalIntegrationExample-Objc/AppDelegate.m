//
//  AppDelegate.m
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import "AppDelegate.h"
@import UserNotifications;
@import BDPointSDK;
@import CoreBluetooth;

@interface AppDelegate() <BDPBluedotServiceDelegate, BDPGeoTriggeringEventDelegate, BDPTempoTrackingDelegate>

@property (nonatomic) NSDateFormatter    *dateFormatter;
@property (nonatomic) UIAlertController  *locationServicesNeverDialog;
@property (nonatomic) UIAlertController  *locationServicesWhileInUseDialog;
@property (nonatomic) UIAlertController  *accuracyAuthorizationReducedDialog;
@property (nonatomic) UIAlertController  *lowPowerModeDialog;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Assign the delegates for session handling and location updates to this class.
    BDLocationManager.instance.bluedotServiceDelegate = self;
    BDLocationManager.instance.geoTriggeringEventDelegate = self;
    BDLocationManager.instance.tempoTrackingDelegate = self;
    
    //request authorization for notification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"notification error");
                              }
                          }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//MARK:- BDPBluedotServiceDelegate protocol - Bluedot service level events

//MARK: Called when Device's low power mode status changed
- (void)lowPowerModeDidChange:(bool)isLowPowerMode
{
    if ( _lowPowerModeDialog == nil )
    {
        NSString  *title = @"Low Power Mode";
        NSString  *message = [ NSString stringWithFormat: @"Low Power Mode has been enabled on this device.  To restore full location precision, disable the setting at :\nSettings → Battery → Low Power Mode" ];
        
        _lowPowerModeDialog = [ UIAlertController
                               alertControllerWithTitle: title
                                                message: message
                                         preferredStyle: UIAlertControllerStyleAlert ];
    }

    if(isLowPowerMode){
        [self.window.rootViewController presentViewController: _lowPowerModeDialog animated: YES completion: nil ];
    } else {
        [ _lowPowerModeDialog dismissViewControllerAnimated: YES completion: nil ];
    }
}

//MARK: Called when location authorization status changed

- (void)locationAuthorizationDidChangeFromPreviousStatus:(CLAuthorizationStatus)previousAuthorizationStatus toNewStatus:(CLAuthorizationStatus)newAuthorizationStatus
{
    
    if ( _locationServicesNeverDialog == nil )
    {
        NSString  *appName = [ NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleDisplayName" ];
        NSString  *title = @"Location Services Required";
        NSString  *message = [ NSString stringWithFormat: @"This App requires Location Services which are currently set to disabled.  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n%@ ✓", appName ];
        
        _locationServicesNeverDialog =
            [ UIAlertController
             alertControllerWithTitle: title
                              message: message
                       preferredStyle: UIAlertControllerStyleAlert ];
        
    }
    
    if (_locationServicesWhileInUseDialog == nil) {
        NSString *title = @"Location Services set to 'While in Use'";
        NSString *message = [NSString stringWithFormat:@"You can ask for further location permission from user via this delegate method"];
        
        _locationServicesWhileInUseDialog = [UIAlertController
            alertControllerWithTitle:title
                             message:message
                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
        [_locationServicesWhileInUseDialog addAction:dismiss];
    }
    
    
    
    switch(newAuthorizationStatus)
    {
        case kCLAuthorizationStatusDenied:
            [self.window.rootViewController presentViewController: _locationServicesNeverDialog animated: YES completion: nil ];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: [self.window.rootViewController presentViewController: _locationServicesWhileInUseDialog animated: YES completion: nil ];
            break;
        default:
        {
            UIViewController *currentPresentedViewController = self.window.rootViewController.presentedViewController;
            if([currentPresentedViewController isKindOfClass:[UIAlertController class]])
            {
                [currentPresentedViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        break;
    }
}

//MARK: Called when location accuracy authorization status changed
- (void)accuracyAuthorizationDidChangeFromPreviousAuthorization:(CLAccuracyAuthorization)previousAccuracyAuthorization toNewAuthorization:(CLAccuracyAuthorization)newAccuracyAuthorization
{
    if ( _accuracyAuthorizationReducedDialog == nil )
    {
        NSString  *appName = [ NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleDisplayName" ];
        NSString  *title = @"Full Accuracy Required";
        NSString  *message = [ NSString stringWithFormat: @"This App requires Full Accuracy Authorization which are currently set to Reduced Accuracy.  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n%@ ✓", appName ];
        
        _accuracyAuthorizationReducedDialog =
            [ UIAlertController
             alertControllerWithTitle: title
                              message: message
                       preferredStyle: UIAlertControllerStyleAlert ];
        
    }

    switch (newAccuracyAuthorization) {
        case CLAccuracyAuthorizationReducedAccuracy:
            [self.window.rootViewController presentViewController: _accuracyAuthorizationReducedDialog animated: YES completion: nil ];
            break;
        default:
            [ _accuracyAuthorizationReducedDialog dismissViewControllerAnimated: YES completion: nil ];
            break;
    }
}

//MARK: Called when Bluedot service received error
- (void)bluedotServiceDidReceiveError:(NSError *)error
{
    NSLog(@"bluedotServiceDidReceiveError: %@", error.localizedDescription);
}

//MARK:- Conform to BDPGeoTriggeringDelegate protocol - call-backs which Point SDK makes to inform the Application of zone updates / checkin / checkout related events

//MARK: This method is passed the Zone information utilised by the Bluedot SDK.
- (void)onZoneInfoUpdate:(NSSet<BDZoneInfo *> *)zoneInfos
{
    NSLog( @"Point sdk updated with %lu zones", (unsigned long)zoneInfos.count );
}

//MARK: checked into a zone
- (void)didEnterZone:(BDZoneEntryEvent *)enterEvent
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *formattedDate = [ _dateFormatter stringFromDate: enterEvent.location.timestamp ];
    
    NSString *message = [ NSString stringWithFormat: @"You have checked into fence '%@' in zone '%@', at %@",enterEvent.fence.name, enterEvent.zone.name, formattedDate ];
    
    [ self showAlert: message ];
    
}

//MARK: Checked out from a zone
- (void)didExitZone:(BDZoneExitEvent *)exitEvent
{
    NSString *message = [ NSString stringWithFormat: @"You left '%@' in zone '%@' after %lu minutes",exitEvent.fence.name, exitEvent.zone.name, (unsigned long)exitEvent.duration ];
    
    [ self showAlert: message ];
}

//MARK:- Conform to BDPTempoTrackingDelegate protocol - call-backs which Point SDK makes to inform the Application of Tempo related events
- (void)tempoTrackingDidExpire
{
    NSLog(@"tempoTrackingDidExpire");
}

- (void)didStopTrackingWithError:(NSError *)error
{
    NSLog(@"didStopTrackingWithError: %@", error.localizedDescription);
}

//MARK:-  Post a notification message.

- (void)showAlert: (NSString *)message
{
    UIApplicationState applicationState = UIApplication.sharedApplication.applicationState;
    
    switch( applicationState )
    {
            // In the foreground: display notification directly to the user
        case UIApplicationStateActive:
        {
            UIAlertController *alertController = [ UIAlertController alertControllerWithTitle: @"Application notification"
                                 message: message
                          preferredStyle: UIAlertControllerStyleAlert ];
            
            UIAlertAction *OK = [ UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil ];
            
            [ alertController addAction:OK ];
            
            [self.window.rootViewController presentViewController: alertController animated: YES completion: nil];
        }
            break;
            
            // If not in the foreground: deliver a local notification
        default:
        {
            UNMutableNotificationContent *content = [UNMutableNotificationContent new];
            content.title = @"BDPoint Notification";
            content.body = message;
            content.sound = [UNNotificationSound defaultSound];
            
            NSString *identifier = @"BDPointNotification";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:nil];
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Notification error: %@",error);
                }
            }];
        }
            break;
    }
}
@end
