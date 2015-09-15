//
//  Movie.h
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSNumber *year;
@property (nonatomic) NSNumber *runtime;
@property (nonatomic) NSArray *cast;
@property (nonatomic) NSURL *reviewsURL;
@property (nonatomic) NSURL *thumbnailPosterURL;
@property (nonatomic) NSURL *originalPosterURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
