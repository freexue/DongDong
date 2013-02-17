//
//  HTTPTrackRequest.m
//  TestUI
//
//  Created by Ye Ke on 1/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "HTTPTrackRequest.h"


@implementation HTTPTrackRequest
@synthesize delegate;

-(ASIFormDataRequest *)packageRequest:(NSString *)urlstr withData:(NSDictionary *)params {
    
    NSURL * url = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
    
    for(NSString *key in params.allKeys)
    {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    
    [request setDelegate:self];
    [request setDidFinishSelector : @selector ( requestFinished: )];
    [request setDidFailSelector : @selector (requestFailed:)];
    
    int tag = arc4random()%100;
    NSLog(@"==Package Request: %d", tag);
    request.tag = tag;
    
    return request;
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString * responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSLog(@"==Success Request: %d", request.tag);
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSError * error = [request error];
    NSLog(@"%@",error.description);
    
    NSLog(@"WARNING!==Failed Request: %d", request.tag);
}
@end
