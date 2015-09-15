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
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end

@implementation MovieCollectionViewCell

#pragma mark - Accessors -

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    [self setup];
}

#pragma mark - General Methods -

- (void)setup {
    
    if (self.downloadTask) {
        [self.downloadTask suspend];
        [self.downloadTask cancel];
    }
    
    NSURL *posterURL = self.movie.originalPosterURL;
    self.posterImageView.image = nil;
    NSURLSession *session = [NSURLSession sharedSession];
    self.downloadTask = [session downloadTaskWithURL:posterURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([posterURL isEqual:self.movie.originalPosterURL]) {
                    self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                }
            });
        }
    }];
    
    [self.downloadTask resume];
}

@end
