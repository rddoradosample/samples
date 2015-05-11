//
//  ImageDownloader.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDownloader : NSObject

- (id)init;
- (void)downloadImageUrl:(NSString *)imageURL forTableView:(UITableView *)tableView forCellIndexPath:(NSIndexPath *)indexPath;

@end