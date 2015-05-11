//
//  Request.h
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REQhttpTimeOut 30.0
#define REQhttpError 500
#define REQhttpSuccess 200

@protocol RequestDelegate <NSObject>

@required
- (void)requestCompleted:(id)sender;

@end


@interface Request : NSObject

@property (nonatomic, assign) id<RequestDelegate> delegate;
@property (nonatomic, readonly, assign) NSInteger resultCode;
@property (nonatomic, readonly, strong) NSDictionary *parsedDictionary;

- (id)initWithDelegate:(id)delegate withUrl:(NSString*)url selector:(SEL)selector;
- (void)execute;

@end