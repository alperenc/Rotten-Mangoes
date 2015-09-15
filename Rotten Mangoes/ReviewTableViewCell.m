//
//  ReviewTableViewCell.m
//  Rotten Mangoes
//
//  Created by Alp Eren Can on 14/09/15.
//  Copyright © 2015 Alp Eren Can. All rights reserved.
//

#import "ReviewTableViewCell.h"

@interface ReviewTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticLabel;

@end

@implementation ReviewTableViewCell

#pragma mark - Accessors -

- (void)setReview:(Review *)review {
    _review = review;
    
    [self setup];
}

#pragma mark - General Methods -

- (void)setup {
    
    self.quoteLabel.text = self.review.quote;
    self.criticLabel.text = self.review.critic;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
