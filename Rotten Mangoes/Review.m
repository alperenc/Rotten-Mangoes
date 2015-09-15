//
//  Review.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Review.h"

@implementation Review

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.critic = dictionary[@"critic"];
        self.quote = dictionary[@"quote"];
    }
    return self;
}

@end
