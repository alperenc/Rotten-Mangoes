//
//  TheaterLocations.h
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 15/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TheaterInfo : NSObject

+ (void)theatersForMovieName:(NSString *)movieName atZipCode:(NSString*)zipCode completion:(void (^)(NSArray *info, NSError *error))completionBlock;

@end
