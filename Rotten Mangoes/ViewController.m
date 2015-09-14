//
//  ViewController.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"

@interface ViewController ()

@property (nonatomic) NSArray *movies;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *API_KEY = @"j9fhnct2tp8wu2q9h75kanh9";
    
    NSURL *baseURL = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/"];
    NSURL *inTheatersURL = [NSURL URLWithString:[NSString stringWithFormat:@"in_theaters.json?apikey=%@&page_limit=1", API_KEY] relativeToURL:baseURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:inTheatersURL];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (!err) {
            
            NSMutableArray *moviesList = [NSMutableArray array];
            
            for (NSDictionary *movieDict in jsonDictionary[@"movies"]) {
                
                Movie *movie = [[Movie alloc] initWithTitle:movieDict[@"title"]];
                movie.year = movieDict[@"year"];
                movie.runtime = movieDict[@"runtime"];
                movie.posterLinks = movieDict[@"posters"];
                
                [moviesList addObject:movie];
            }
            
            self.movies = [moviesList copy];
            NSLog(@"%@", jsonDictionary);
        }
        
    }];
    
    [dataTask resume];

}

@end
