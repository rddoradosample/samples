//
//  News.m
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "News.h"
#import "Request.h"

@interface News()

@property (nonatomic, assign) NSInteger resultCode;

@end

@implementation News

#pragma mark - Public Methods
- (id)initWithDelegate:(id)delegate {
    
    if(self = [super init])
    {
        _newsArray = [[NSMutableArray alloc] init];
        _delegate = delegate;
    }
    
    return self;
}

- (void)refresh {
    // Get News
    Request *aRequest = [[Request alloc] initWithDelegate:self withUrl:SourceURL selector:@selector(requestCompleted:)];
    [aRequest execute];
}


#pragma mark - Request Delegate Methods
- (void)requestCompleted:(id)sender {
    
    NSDictionary *contentsDictionary = [sender parsedDictionary];
    self.resultCode = [sender resultCode];
    
    if (contentsDictionary) {
        
        self.newsArray = nil;
        NSArray *rows= [contentsDictionary objectForKey:@"solutions"];
        if (rows) {
            self.newsArray = [[NSMutableArray alloc] initWithArray:rows];
        }
        
        // cleanup null objects
        NSMutableIndexSet *removeIndexSet = [NSMutableIndexSet indexSet];
        NSInteger index=0;
        for (id news in self.newsArray) {
            
            // remove null objects
            id name = [news objectForKey:@"name"];
            id newsDescription = [news objectForKey:@"description"];
            id iconUrl = [news objectForKey:@"icon"];
            
            if ([name isKindOfClass:[NSNull class]] &&
                [newsDescription isKindOfClass:[NSNull class]] &&
                [iconUrl isKindOfClass:[NSNull class]]) {
                [removeIndexSet addIndex:index];
            }
            index++;
        }
        
        [self.newsArray removeObjectsAtIndexes:removeIndexSet];
        
        [self delegateCallback];
    }
    else {
        self.newsArray = nil;
    }
    
}

#pragma mark - Delegate Callback

- (void)delegateCallback
{
    // Call notification selector if one exists
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsDidUpdate:)]) {
        [self.delegate performSelector:@selector(newsDidUpdate:) withObject:self];
    }
}

@end