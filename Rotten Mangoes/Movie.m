//
//  Movie.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.year = dictionary[@"year"];
        self.runtime = dictionary[@"runtime"];
        self.cast = dictionary[@"abridged_cast"];
        self.links = dictionary[@"links"];
        
        NSMutableDictionary *mutablePosters = [dictionary[@"posters"] mutableCopy];
        NSString *originalURLString = mutablePosters[@"original"];
//        NSLog(@"%@", originalURLString);
        mutablePosters[@"original"] = [NSString stringWithFormat:@"http://%@", [originalURLString substringFromIndex:([originalURLString rangeOfString:@"dkpu1ddg7pbsk.cloudfront.net"].location)]];
        
        self.posterLinks = [mutablePosters copy];
    }
    return self;
}

@end
