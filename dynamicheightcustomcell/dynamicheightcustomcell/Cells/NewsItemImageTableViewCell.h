//
//  NewsItemImage.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "NewsItemTableViewCell.h"

static NSString *NewsItemImageTableViewCellIdentifier = @"NewsItemImageTableViewCell";

@interface NewsItemImageTableViewCell : NewsItemTableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *rightImageView;

@end
