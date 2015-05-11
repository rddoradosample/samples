//
//  NewsItemTableViewCell.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *NewsItemTableViewCellIdentifier = @"NewsItemTableViewCell";

#define kImageHeight 80

@interface NewsItemTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *descriptionLabel;

- (CGSize)sizeForLabel:(UILabel *)label;

@end