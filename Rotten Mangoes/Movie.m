//
//  Movie.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "Movie.h"
#import "Review.h"

@implementation Movie

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.year = dictionary[@"year"];
        self.runtime = dictionary[@"runtime"];
        self.cast = dictionary[@"abridged_cast"];
        self.reviewsURL = dictionary[@"links"][@"reviews"];
        self.thumbnailPosterURL = [NSURL URLWithString:dictionary[@"posters"][@"thumbnail"]];
        self.originalPosterURL = [self getOriginalPosterURL:dictionary[@"posters"][@"original"]];
    }
    return self;
}

- (NSURL *)getOriginalPosterURL:(NSString *)originalURLString {
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [originalURLString substringFromIndex:([originalURLString rangeOfString:@"dkpu1ddg7pbsk.cloudfront.net"].location)]]];
}

@end
