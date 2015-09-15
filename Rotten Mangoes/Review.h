//
//  Review.h
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (nonatomic) NSString *critic;
@property (nonatomic) NSString *quote;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
