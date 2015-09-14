//
//  ViewController.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "MovieCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *API_KEY = @"j9fhnct2tp8wu2q9h75kanh9";
    
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
            
//            NSLog(@"%@", jsonDictionary);
        }
        
    }];
    
    [dataTask resume];

}

#pragma mark - UICollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *movieCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    Movie *movie = self.movies[indexPath.row];

    NSURL *posterURL = [NSURL URLWithString:movie.posterLinks[@"original"]] ;
    NSLog(@"%@", posterURL);
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:posterURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"%@", [location absoluteString]);
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                movieCell.posterImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            });
            
        }
    }];
    
    [downloadTask resume];
    
    return movieCell;
}

@end
