//
//  NewsItemTableViewCell.m
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "NewsItemTableViewCell.h"


@interface NewsItemTableViewCell()


@end

@implementation NewsItemTableViewCell


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGSize)sizeForLabel:(UILabel *)label {
    
    NSAssert(self, @"UILabel was nil");
    
    //Label text
    NSString *aLabelTextString = label.text;
    
    //Label font
    UIFont *aLabelFont = label.font;
    
    //Width of the Label
    CGFloat aLabelSizeWidth = label.frame.size.width;
    
    self.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CGRectGetHeight(self.bounds));
    
    if ([aLabelTextString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        //version >= 7.0
        
        //Return the calculated size of the Label
        return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                                        NSFontAttributeName : aLabelFont
                                                        }
                                              context:nil].size;
        
    }
    else {
        // pre-iOS 7.0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [aLabelTextString sizeWithFont:aLabelFont
                            constrainedToSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
    }
    
    return [self bounds].size;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.titleLabel.frame);
    self.descriptionLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.descriptionLabel.frame);
}


@end