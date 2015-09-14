//
//  Movie.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}

@end
