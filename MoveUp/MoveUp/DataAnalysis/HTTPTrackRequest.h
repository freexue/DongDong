//
//  HTTPTrackRequest.h
//  TestUI
//
//  Created by Ye Ke on 1/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

@protocol HTTPTrackRequestDelegate <NSObject>

- (void)networkNotReachable;
- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void)addRequstToPool:(ASIHTTPRequest *)request;
- (void)queueFinished:(ASINetworkQueue *)queue;
- (void)notProcessReturned:(NSMutableDictionary*)context;

@end

@interface HTTPTrackRequest : NSObject {
    
}
@property(nonatomic,assign) id<HTTPTrackRequestDelegate> delegate;

-(ASIFormDataRequest *)packageRequest:(NSString *)urlstr withData:(NSDictionary *)params;
@end
