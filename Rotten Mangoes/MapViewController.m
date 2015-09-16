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
#import "TheaterInfo.h"
#import "Theater.h"

#define zoominMapArea 30000

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
    
    [TheaterInfo theatersForMovieName:self.movieName atZipCode:self.userZipCode completion:^(NSArray *info, NSError *error) {
        if (!error){
            
            for (NSDictionary *theaterInfo in info){
                
                NSString *name = theaterInfo[@"name"];
                NSString *address = theaterInfo[@"address"];
                NSNumber *lat = theaterInfo[@"lat"];
                NSNumber *lng = theaterInfo[@"lng"];
                
                Theater *theater = [[Theater alloc] initWithCoordinate:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]) title:name subtitle:address];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.mapView addAnnotation:theater];
                });
            }
        }
    }];
    
}

#pragma mark - MKMapView delegate -

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    if (!self.userLocationUpdated) {
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate
                                 animated:YES];
        self.userLocationUpdated = YES;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = placemarks[0];
            self.userZipCode = placemark.postalCode;
            
            [self initiateMap];
        }];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"theaterAnno"];
    
    pinView.canShowCallout = YES;
    
    return pinView;
}

@end
