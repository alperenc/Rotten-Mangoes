//
//  MapViewController.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 15/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

#define zoominMapArea 2000

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSString *userZipCode;

@property (nonatomic) BOOL userLocationUpdated;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.mapView = nil;
}

- (void) initiateMap {
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.currentLocation = [[CLLocation alloc] initWithLatitude:appDelegate.currentLocation.coordinate.latitude longitude:appDelegate.currentLocation.coordinate.longitude];
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

#pragma mark - MKMapView delegate -

- (void)mapViewDidFinishLoadingMap:(nonnull MKMapView *)mapView{
    [self initiateMap];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (!self.userLocationUpdated) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate
                                 animated:YES];
        self.userLocationUpdated = YES;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
            self.userZipCode = placemark.postalCode;
            
            NSLog(@"%@", self.userZipCode);
        }];
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
