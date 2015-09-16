//
//  TheaterLocations.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 15/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "TheaterInfo.h"

@implementation TheaterInfo

+ (void)theatersForMovieName:(NSString *)movieName atZipCode:(NSString*)zipCode completion:(void (^)(NSArray *info, NSError *error))completionBlock {
    NSString *baseURL = @"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?";
    
    NSURLRequest *getTheaters = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@address=%@&movie=%@", baseURL, zipCode, [movieName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:getTheaters completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError;
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            if (!jsonError) {
                NSLog(@"Theatre locations recieved and parse successfully");
                NSArray *theatres = json[@"theatres"];
                
                completionBlock(theatres, error);
            } else {
                completionBlock([NSArray array], error);
                NSLog(@"Theatre locations received but json parsing failed :(, with error %@", jsonError.description);
            }
        } else {
            completionBlock([NSArray array], error);
            NSLog(@"Theatre locations retrieval failed :(, with error %@", error.description);
        }
    }];
    
    [dataTask resume];
}

@end
