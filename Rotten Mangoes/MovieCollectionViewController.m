//
//  ViewController.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "MovieCollectionViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieReviewsViewController.h"
#import "Constants.h"

//#define NSString *const API_KEY = @"j9fhnct2tp8wu2q9h75kanh9";

@interface MovieCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MovieCollectionViewController

#pragma mark - View Controller Life Cycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getInitialData];
}

#pragma mark - UICollectionView Data Source -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    movieCell.movie = self.movies[indexPath.row];
    return movieCell;
}

#pragma mark - UICollectionView Delegate -
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showMovieReviews" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - General Methods -

- (void)getInitialData {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/"];
    NSURL *inTheatersURL = [NSURL URLWithString:[NSString stringWithFormat:@"in_theaters.json?apikey=%@&page_limit=40", API_KEY] relativeToURL:baseURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:inTheatersURL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (!err) {
            
            NSMutableArray *moviesList = [NSMutableArray array];
            
            for (NSDictionary *movieDict in jsonDictionary[@"movies"]) {
                
                Movie *movie = [[Movie alloc] initWithDictionary:movieDict];
                [moviesList addObject:movie];
            }
            
            self.movies = [moviesList copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MovieCollectionViewCell *)sender {
    if ([segue.identifier isEqualToString:@"showMovieReviews"]) {
        MovieReviewsViewController *movieReviewsVC = (MovieReviewsViewController *)[segue destinationViewController];
        movieReviewsVC.movie = sender.movie;
    }
}

@end
