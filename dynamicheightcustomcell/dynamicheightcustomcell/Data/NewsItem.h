//
//  NewsItem.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *newsDescription;
@property (nonatomic, retain) NSString *iconUrl;
@property (nonatomic, retain) NSString *url;


- (id)initWithDictionary:(NSDictionary*)newsItem;

@end
