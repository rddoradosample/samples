//
//  ImageDownloader.m
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "ImageDownloader.h"
#import <Foundation/Foundation.h>
#import "ImageDownloader.h"
#import "NewsItemImageTableViewCell.h"

@interface ImageDownloader()

@property (nonatomic, retain) NSString *imageURL;

@end

@implementation ImageDownloader


// Shared cache for downloaded images
static NSMutableDictionary *_imageCache = nil;

- (id)init
{
    if (self = [super init])
    {
        // Init members
        _imageURL = nil;
        // Alloc cache once
        if (_imageCache == nil)
        {
            _imageCache = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

- (void)downloadImageUrl:(NSString *)imageURL forTableView:(UITableView *)tableView forCellIndexPath:(NSIndexPath *)indexPath {
    
    self.imageURL = imageURL;
    // Check if already in image cache
    if ([_imageCache objectForKey:self.imageURL] != nil)
    {
        // In cache, so use assign it to image view
        dispatch_async(dispatch_get_main_queue(), ^{
            // Capture the indexPath variable, not the cell variable, and use that
            NewsItemImageTableViewCell *blockCell = (NewsItemImageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            blockCell.rightImageView.image = [_imageCache objectForKey:imageURL];
            [blockCell setNeedsLayout];
            
        });
    }
    else {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
            UIImage* image = [[UIImage alloc] initWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Capture the indexPath variable, not the cell variable, and use that
                NewsItemImageTableViewCell *blockCell = (NewsItemImageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
                blockCell.rightImageView.image = image;
                [blockCell setNeedsLayout];
                if (image != nil) {
                    // If there is an existing image. Let's remove this and store the new one.
                    [_imageCache setObject:image forKey:self.imageURL];
                }
            });
        });
    }
}

@end