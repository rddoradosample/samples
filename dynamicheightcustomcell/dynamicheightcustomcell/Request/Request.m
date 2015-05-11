//
//  Request.m
//  dynamicheightcustomcell
//
//  Created by Ronaldo II Dorado on 11/5/15.
//  Copyright (c) 2015 Ronaldo II Dorado. All rights reserved.
//

#import "Request.h"
#import <UIKit/UIKit.h>

@interface Request()

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic) SEL notifySelector;
@property (nonatomic, retain) NSURLConnection *conn;
@property (nonatomic, retain) NSMutableString *parseString;
@property (nonatomic, retain) NSMutableData *respData;
@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, strong) NSDictionary *parsedDictionary;
@property (nonatomic, assign) BOOL isNotificationSent;

@end

@implementation Request

- (id)initWithDelegate:(id)delegate withUrl:(NSString*)url selector:(SEL)selector
{
    if (self = [super init])
    {
        // Init members
        _delegate = delegate;
        _notifySelector = selector;
        _urlString = url;
        _respData = [[NSMutableData alloc] init];
        _parseString = nil;
        _resultCode = 0;
        _parsedDictionary = [[NSDictionary alloc] init];
        
    }
    return self;
}

- (void)execute
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.urlString]];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:REQhttpTimeOut];
    [req setHTTPMethod:@"GET"];
    [req setHTTPBody:nil];
    
    // Start connection
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (!self.conn)
    {
        // Log error
        NSLog(@"Error: Unable to create network connection");
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        
        // Set error result
        self.resultCode = REQhttpError;
        
        // Notify delegate
        [self delegateCallback];
    }
}

- (void)parse
{
    // Convert NSdata to NSString because JSONObjectWithData to get proper encoding
    NSString *jsonString = [[NSString alloc] initWithData:self.respData encoding:NSISOLatin1StringEncoding];
    if (!jsonString)
    {
        // NSISOLatin1StringEncoding not working try NSUTF8StringEncoding
        jsonString = [[NSString alloc] initWithData:self.respData encoding:NSUTF8StringEncoding];
    }
    // Convert NSString back to NSData for JSON Serialization
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Do JSON serialization
    NSError* error=nil;
    NSDictionary *jsonDict = [NSJSONSerialization
                              JSONObjectWithData:jsonData
                              options:kNilOptions
                              error:&error];
    
    self.parsedDictionary = nil;
    self.parsedDictionary = jsonDict;
    
    if (error) {
        // Parser failed.
        self.resultCode = REQhttpError;
    }
    else {
        self.resultCode = REQhttpSuccess;
    }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Check for error response
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    if (statusCode != 200)
    {
        // Log error
        NSLog(@"Error: HTTP request returned error: %d", (int)statusCode);
        
        // Cancel connection
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
        [connection cancel];
        
        // Set error result
        self.resultCode = statusCode;
        
        // Notify delegate
        [self delegateCallback];
    }
    else
    {
        // Reset data
        [self.respData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append data
    [self.respData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release connection
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
    
    // Set error result
    self.resultCode = REQhttpError;
    
    // Notify delegate
    [self delegateCallback];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse response
    [self parse];
    
    // Release connection
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:FALSE];
    
    // Notify delegate
    [self delegateCallback];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)space
{
    return [space.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - Delegate Callback
- (void)delegateCallback
{
    // Call notification selector if one exists
    if (self.delegate && [self.delegate respondsToSelector:self.notifySelector])
    {
        self.isNotificationSent = YES;
        
        [self.delegate performSelector:@selector(requestCompleted:) withObject:self];
    }
}

@end

