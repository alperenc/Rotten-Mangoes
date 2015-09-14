//
//  MovieCollectionViewCell.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "MovieCollectionViewCell.h"

@interface MovieCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end

@implementation MovieCollectionViewCell

#pragma mark - Accessors -

- (void)setObject:(Movie *)object {
    _object = object;
    
    [self setup];
}

#pragma mark - General Methods -

- (void)setup {

    NSString *posterString = self.object.posterLinks[@"original"];
    NSURL *posterURL = [NSURL URLWithString:posterString];
    self.posterImageView.image = nil;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:posterURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([posterString isEqualToString:self.object.posterLinks[@"original"]]) {
                    self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                }
            });
        }
    }];
    
    [downloadTask resume];
}

@end
