//
//  MovieReviewsViewController.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "MovieReviewsViewController.h"
#import "ReviewTableViewCell.h"
#import "Constants.h"

@interface MovieReviewsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UITableView *reviewsTableView;

@property (nonatomic) NSMutableArray *reviews;

@end

@implementation MovieReviewsViewController

#pragma mark - View Controller Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.movie.title;
    
    NSURL *posterURL = self.movie.originalPosterURL;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:posterURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([posterURL isEqual:self.movie.originalPosterURL]) {
                    self.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                }
            });
        }
    }];
    
    [downloadTask resume];
    
    NSURLRequest *getReviews = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?apikey=%@", self.movie.reviewsURL, API_KEY]]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:getReviews completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            
            NSError *jsonError;
            NSDictionary *reviewsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            
            NSMutableArray *reviewsList = [NSMutableArray array];
            
            for (NSDictionary *reviewDict in reviewsDictionary[@"reviews"]) {
                Review *review = [[Review alloc] initWithDictionary:reviewDict];
                [reviewsList addObject:review];
            }
            
            self.reviews = [reviewsList copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.reviewsTableView reloadData];
            });
        }
    }];
    
    [dataTask resume];
}

#pragma mark - UITableView Data Source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
    
    cell.review = self.reviews[indexPath.row];
    
    return cell;
}

#pragma mark - UITableView Delegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Reviews";
}

@end
