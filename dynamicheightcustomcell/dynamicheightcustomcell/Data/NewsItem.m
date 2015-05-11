//
//  NewsItem.m
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (id)initWithDictionary:(NSDictionary*)newsItem {
    if (self = [super init]) {
        _name = @"";
        _newsDescription = @"";
        _iconUrl = @"";
        _url = @"";
        
        if (newsItem) {
            id name = [newsItem objectForKey:@"name"];
            id newsDescription = [newsItem objectForKey:@"description"];
            id iconUrl = [newsItem objectForKey:@"icon"];
            
            if (![name isKindOfClass:[NSNull class]]) {
                _name = [newsItem objectForKey:@"name"];
            }
            if (![newsDescription isKindOfClass:[NSNull class]]) {
                _newsDescription = [newsItem objectForKey:@"description"];
            }
            if (![iconUrl isKindOfClass:[NSNull class]]) {
                _iconUrl = [newsItem objectForKey:@"icon"];
            }
            if (![iconUrl isKindOfClass:[NSNull class]]) {
                _url = [newsItem objectForKey:@"url"];
            }
        }
        
        // Check for null
        if (!_name) _name = @"";
        if (!_newsDescription) _newsDescription = @"";
        if (!_iconUrl) _iconUrl = @"";
        if (!_url) _url = @"";
    }
    return self;
}

@end