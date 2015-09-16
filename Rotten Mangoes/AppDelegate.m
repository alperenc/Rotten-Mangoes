//
//  AppDelegate.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self startLocationManager];
}

-(void)setUpLocationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = 10;
        //have to move 100m before location manager checks again
        
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        NSLog(@"new location Manager in startLocationManager");
        
    }
    
    [_locationManager startUpdatingLocation];
    NSLog(@"Start Regular Location Manager");
}

- (void)startLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setUpLocationManager];
            
        } else if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)){
            [self setUpLocationManager];
            
        }else{
            UIAlertController *alertController =[UIAlertController alertControllerWithTitle:@"Enable Location Services"
                                                                              message:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Play"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
            [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            
        }
    }
}

-(void)stopLocationManager{
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager) {
            [_locationManager stopUpdatingLocation];
            NSLog(@"Stop Regular Location Manager");
        }
    }
}

-(void)locationManager:(nonnull CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation * loc = [locations lastObject];
    
    NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",[NSDate date],loc.coordinate.latitude, loc.coordinate.longitude, loc.horizontalAccuracy, loc.horizontalAccuracy, fabs([loc.timestamp timeIntervalSinceNow]));
    
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0){
        NSLog(@"locationAge is %1.2f",locationAge);
        return;
    }
    
    if (loc.horizontalAccuracy < 0){
        NSLog(@"loc.horizontalAccuracy is %1.2f",loc.horizontalAccuracy);
        return;
    }
    
    if (_currentLocation == nil || _currentLocation.horizontalAccuracy >= loc.horizontalAccuracy){
        _currentLocation = loc;
        
        if (loc.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            [self stopLocationManager];
        }
    }
}

@end
