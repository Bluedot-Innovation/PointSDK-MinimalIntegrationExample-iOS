//
//  ViewController.m
//  PointSDK-MinimalIntegrationExample-iOS-ObjC
//
//  Created by Bluedot Innovation
//  Copyright (c) 2016 Bluedot Innovation. All rights reserved.
//

#import "ViewController.h"
@import BDPointSDK;
#import <UserNotifications/UserNotifications.h>
#import "AuthenticationHandler.h"

@interface ViewController () <BDPSessionDelegate, BDPLocationDelegate>

@property (nonatomic) NSDateFormatter    *dateFormatter;
@property (nonatomic) UIAlertController  *userInterventionForBluetoothDialog;
@property (nonatomic) UIAlertController  *userInterventionForLocationServicesNeverDialog;
@property (nonatomic) UIAlertController  *userInterventionForLocationServicesWhileInUseDialog;
@property (nonatomic) UIAlertController  *userInterventionForPowerModeDialog;

@end

@implementation ViewController

BDLocationManager  *locationManager = nil;

//Add API key for the App
NSString  *apiKey = @"";

//Add Package name for the App
NSString  *packageName = @"";

//Add Registration email Id
NSString  *username = @"";

NSString  *EXResponseError = @"BDResponseErrorInfoKeyName";


- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view, typically from a nib.
    
    locationManager = BDLocationManager.instance;
    
    //Assign the delegates for session handling and location updates to this class.
    locationManager.sessionDelegate = self;
    locationManager.locationDelegate = self;
    
    //Determine the authentication state
    switch( locationManager.authenticationState )
    {
        case BDAuthenticationStateNotAuthenticated:
        {
            AuthenticationHandler *authenticationHandler = [[AuthenticationHandler alloc] initWithUserName: username andApiKey:  apiKey andPackageName:  packageName];
            
            [ authenticationHandler authenticate ];
            
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
    switch( locationManager.authenticationState )
    {
        case BDAuthenticationStateAuthenticated:
            [ locationManager logOut ];
            break;
            
        default:
            break;
    }
    
}

//MARK:- Conform to BDPSessionDelegate protocol - Point SDK's session related callbacks

- (void)willAuthenticateWithApiKey: (NSString *)apiKey
{
    NSLog( @"Authenticating with Point sdk" );
}


- (void)authenticationWasSuccessful
{
    NSLog( @"Authenticated successfully with Point sdk" );
}

- (void)authenticationWasDeniedWithReason: (NSString *)reason
{
    NSLog( @"Authentication with Point sdk denied, with reason: %@", reason );
    
    UIAlertController *alertController = [ UIAlertController alertControllerWithTitle:
                                          @"Authentication Denied" message: reason
                                                                       preferredStyle: UIAlertControllerStyleAlert ];
    
    UIAlertAction *OK = [ UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil ];
    
    [ alertController addAction:OK ];
    
    [ self presentViewController: alertController animated: YES completion: nil ];
}


- (void)authenticationFailedWithError: (NSError *)error
{
    NSLog( @"Authentication with Point sdk failed, with reason: %@", error.localizedDescription );
    
    NSString  *title;
    NSString  *message;
    
    //  BDResponseError will be more conveniently exposed in the next version
    BOOL isConnectionError = ( error.userInfo[ EXResponseError ] == NSURLErrorDomain );
    
    if ( isConnectionError == YES )
    {
        title = @"No data connection?";
        message = @"Sorry, but there was a problem connecting to Bluedot servers.\n"
        "Please check you have a data connection, and that flight mode is disabled, and try again.";
    }
    else
    {
        title = @"Authentication Failed";
        message = error.localizedDescription;
    }
    
    UIAlertController *alertController = [ UIAlertController alertControllerWithTitle: title
                                                                              message: message
                                                                       preferredStyle: UIAlertControllerStyleAlert ];
    
    UIAlertAction *OK = [ UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil ];
    
    [ alertController addAction:OK ];
    
    [ self presentViewController: alertController animated: YES completion: nil ];
}


- (void)didEndSession
{
    NSLog( @"Logged out" );
}

- (void)didEndSessionWithError: (NSError *)error
{
    NSLog( @"Logged out with error: %@", error.localizedDescription );
    
}

//MARK:- Conform to BDPLocationDelegate protocol - call-backs which Point SDK makes to inform the Application of location-related events

//MARK: This method is passed the Zone information utilised by the Bluedot SDK.
- (void)didUpdateZoneInfo: (NSSet *)zones
{
    NSLog( @"Point sdk updated with %lu zones", (unsigned long)zones.count );
    
}

//MARK: checked into a zone
//fence         - Fence triggered
//zoneInfo      - Zone information Fence belongs to
//location      - Geographical coordinate where trigger happened
//customData    - Custom data associated with this Custom Action

- (void)didCheckIntoFence: (BDFenceInfo *)fence
                   inZone: (BDZoneInfo *)zoneInfo
               atLocation: (BDLocationInfo *)location
             willCheckOut: (BOOL)willCheckOut
           withCustomData: (NSDictionary *)customData
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *formattedDate = [ _dateFormatter stringFromDate: location.timestamp ];
    
    NSString *message = [ NSString stringWithFormat: @"You have checked into fence '%@' in zone '%@', at %@",fence.name, zoneInfo.name, formattedDate ];
    
    [ self showAlert: message ];
    
}

//MARK: Checked out from a zone
//fence             - Fence user is checked out from
//zoneInfo          - Zone information Fence belongs to
//checkedInDuration - Time spent inside the Fence in minutes
//customData        - Custom data associated with this Custom Action

- (void)didCheckOutFromFence: (BDFenceInfo *)fence
                      inZone: (BDZoneInfo *)zoneInfo
                      onDate: (NSDate *)date
                withDuration: (NSUInteger)checkedInDuration
              withCustomData: (NSDictionary *)customData
{
    NSString *message = [ NSString stringWithFormat: @"You left '%@' in zone '%@' after %lu minutes",fence.name, zoneInfo.name, (unsigned long)checkedInDuration ];
    
    [ self showAlert: message ];
}

//MARK: A beacon with a Custom Action has been checked into; display an alert to notify the user.
//beacon         - Beacon triggered
//zoneInfo       - Zone information Beacon belongs to
//location       - Geographical coordinate where trigger happened
//proximity      - Proximity at which the trigger occurred
//customData     - Custom data associated with this Custom Action

- (void)didCheckIntoBeacon: (BDBeaconInfo *)beacon
                    inZone: (BDZoneInfo *)zoneInfo
                atLocation: (BDLocationInfo *)location
             withProximity: (CLProximity)proximity
              willCheckOut: (BOOL)willCheckOut
            withCustomData: (NSDictionary *)customData
{
    NSString *proximityString;
    
    switch(proximity)
    {
        default:
        case CLProximityUnknown:   proximityString = @"Unknown";   break;
        case CLProximityImmediate: proximityString = @"Immediate"; break;
        case CLProximityNear:      proximityString = @"Near";      break;
        case CLProximityFar:       proximityString = @"Far";       break;
    }
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *message = [ NSString stringWithFormat: @"You have checked into beacon '%@' in zone '%@' with proximity %@ at %@",beacon.name,zoneInfo.name,proximityString,[ _dateFormatter stringFromDate: location.timestamp ] ];
    
    [ self showAlert: message ];
    
}


//MARK: A beacon with a Custom Action has been checked out from; display an alert to notify the user.
//beacon               - Beacon triggered
//zoneInfo             - Zone information Beacon belongs to
//checkedInDuration    - Time spent inside the Fence; in minutes
//customData           - Custom data associated with this Custom Action
//proximity            - Proximity at which the trigger occurred

- (void)didCheckOutFromBeacon: (BDBeaconInfo *)beacon
                       inZone: (BDZoneInfo *)zoneInfo
                withProximity: (CLProximity)proximity
                       onDate: (NSDate *)date
                 withDuration: (NSUInteger)checkedInDuration
               withCustomData: (NSDictionary *)customData
{
    NSString *message = [ NSString stringWithFormat: @"You left beacon '%@' in zone '%@', after %lu minutes",
                         beacon.name, zoneInfo.name, (unsigned long)checkedInDuration ];
    
    [ self showAlert: message ];
}

//MARK: This method is part of the Bluedot location delegate and is called when Bluetooth is required by the SDK but is not enabled on the device; requiring user intervention.
- (void)didStartRequiringUserInterventionForBluetooth
{
    if ( _userInterventionForBluetoothDialog == nil )
    {
        NSString  *title = @"Bluetooth Required";
        NSString  *message = @"There are nearby Beacons which cannot be detected because Bluetooth is disabled.  Re-enable Bluetooth to restore full functionality.";
        
        _userInterventionForBluetoothDialog = [ UIAlertController alertControllerWithTitle:
                                               title message: message
                                                                            preferredStyle: UIAlertControllerStyleAlert ];
        
        UIAlertAction *dismiss = [ UIAlertAction actionWithTitle: @"Dismiss" style: UIAlertActionStyleCancel handler: nil ];
        [ _userInterventionForBluetoothDialog addAction: dismiss ];
    }
    
    [ self presentViewController: _userInterventionForBluetoothDialog animated: YES completion: nil ];
}


//MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Bluetooth and either user intervention has enabled Bluetooth or the Bluetooth service is no longer required.

- (void)didStopRequiringUserInterventionForBluetooth
{
    [ _userInterventionForBluetoothDialog dismissViewControllerAnimated: YES completion: nil ];
}

//MARK:  This method is part of the Bluedot location delegate and is called when Location Services are not enabled on the device; requiring user intervention.

- (void)didStartRequiringUserInterventionForLocationServicesAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
    if(authorizationStatus == kCLAuthorizationStatusDenied)
    {
        if ( _userInterventionForLocationServicesNeverDialog == nil )
        {
            NSString  *appName = [ NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleDisplayName" ];
            NSString  *title = @"Location Services Required";
            NSString  *message = [ NSString stringWithFormat: @"This App requires Location Services which are currently set to disabled.  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n%@ ✓", appName ];
            
            _userInterventionForLocationServicesNeverDialog = [ UIAlertController
                                                               alertControllerWithTitle: title
                                                               message: message
                                                               preferredStyle: UIAlertControllerStyleAlert ];
            
        }
        
        UIViewController *currentPresentedViewController = self.presentedViewController;
        if([currentPresentedViewController isKindOfClass:[UIAlertController class]])
        {
            __weak typeof(self) weakSelf = self;
            
            [currentPresentedViewController dismissViewControllerAnimated:YES completion:^(void){
                
                if (weakSelf != nil) {
                    [ weakSelf presentViewController: self-> _userInterventionForLocationServicesNeverDialog animated: YES completion: nil ];
                }
                
            }];
        }
        else
        {
            [ self presentViewController: _userInterventionForLocationServicesNeverDialog animated: YES completion: nil ];
        }
    }
    else if(authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        if (_userInterventionForLocationServicesWhileInUseDialog == nil) {
            NSString *title = @"Location Services set to 'While in Use'";
            NSString *message = [NSString stringWithFormat:@"You can ask for further location permission from user via this delegate method"];
            
            _userInterventionForLocationServicesWhileInUseDialog = [UIAlertController
                                                                    alertControllerWithTitle:title
                                                                    message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
            [_userInterventionForLocationServicesWhileInUseDialog addAction:dismiss];
        }
        
        UIViewController *currentPresentedViewController = self.presentedViewController;
        if([currentPresentedViewController isKindOfClass:[UIAlertController class]])
        {
            __weak typeof(self) weakSelf = self;
            
            [currentPresentedViewController dismissViewControllerAnimated:YES completion:^(void){
                
                if (weakSelf != nil) {
                    [ weakSelf presentViewController: self-> _userInterventionForLocationServicesWhileInUseDialog animated: YES completion: nil ];
                }
                
            }];
        }
        else
        {
            [ self presentViewController: _userInterventionForLocationServicesWhileInUseDialog animated: YES completion: nil ];
        }
    }
    
}

//MARK: This method is part of the Bluedot location delegate; it is called if user intervention on the device had previously been required to enable Location Services and either Location Services has been enabled or the user is no longer within anauthenticated session, thereby no longer requiring Location Services.

- (void)didStopRequiringUserInterventionForLocationServicesAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus
{
    UIViewController *currentPresentedViewController = self.presentedViewController;
    if([currentPresentedViewController isKindOfClass:[UIAlertController class]])
    {
        [currentPresentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

//MARK: This method is part of the Bluedot location delegate and is called when Low Power mode is enabled on the device; requiring user intervention to restore full SDK precision.

- (void)didStartRequiringUserInterventionForPowerMode
{
    if ( _userInterventionForPowerModeDialog == nil )
    {
        NSString  *title = @"Low Power Mode";
        NSString  *message = [ NSString stringWithFormat: @"Low Power Mode has been enabled on this device.  To restore full location precision, disable the setting at :\nSettings → Battery → Low Power Mode" ];
        
        _userInterventionForPowerModeDialog = [ UIAlertController alertControllerWithTitle: title
                                                                                   message: message
                                                                            preferredStyle: UIAlertControllerStyleAlert ];
    }
    
    [ self presentViewController: _userInterventionForPowerModeDialog animated: YES completion: nil ];
}


//MARK: if the user switches off 'Low Power mode', then didStopRequiringUserInterventionForPowerMode is called.
- (void)didStopRequiringUserInterventionForPowerMode
{
    [ _userInterventionForPowerModeDialog dismissViewControllerAnimated: YES completion: nil ];
}


//MARK:-  Post a notifiction message.

- (void)showAlert: (NSString *)message
{
    UIApplicationState applicationState = UIApplication.sharedApplication.applicationState;
    
    switch( applicationState )
    {
            // In the foreground: display notification directly to the user
        case UIApplicationStateActive:
        {
            UIAlertController *alertController = [ UIAlertController alertControllerWithTitle:
                                                  @"Application notification"
                                                                                      message: message
                                                                               preferredStyle: UIAlertControllerStyleAlert ];
            
            UIAlertAction *OK = [ UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleCancel handler: nil ];
            
            [ alertController addAction:OK ];
            
            [ self presentViewController: alertController animated: YES completion: nil ];
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
