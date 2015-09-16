//
//  Theater.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 15/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Theater.h"

@implementation Theater

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;
{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

@end
