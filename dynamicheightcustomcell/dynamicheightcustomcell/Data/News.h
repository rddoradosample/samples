//
//  News.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SourceURL @"https://api.myjson.com/bins/1quht"

@protocol NewsDelegate <NSObject>

- (void)newsDidUpdate:(id)sender;
@end

@interface News : NSObject

@property (nonatomic, strong) NSMutableArray *newsArray;
@property (nonatomic, assign) id<NewsDelegate> delegate;
@property (nonatomic, readonly, assign) NSInteger resultCode;

- (id)initWithDelegate:(id)self;
- (void)refresh;

@end