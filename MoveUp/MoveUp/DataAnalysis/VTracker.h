//
//  VTracker.h
//  TestUI
//
//  Created by Ye Ke on 1/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "HTTPTrackRequest.h"
#import "UserData.h"
#import "ExerciseBehavior.h"
#import "LongTermBehavior.h"


@interface VTracker : NSObject{
    ASINetworkQueue * networkQueue;
    NSDate * viewTime;   //Recount from every UIView
    NSDate * sessionTime;   //Count until run in background
}

+(VTracker *)tracker;
//Data Encoding and Decoding
-(NSString *)encodeInfo:(id)info;
-(NSDictionary *)decodeInfo:(NSData *)data;

//Access Method: Raw Data -> JSON -> Request -> Put into queue
-(void)addRequestToQueue:(id)info toAccess:(NSString *)webAcc JSONED:(Boolean)ifneed;

//Package methods:
-(void)packageBehaviors;
-(void)packageUerInfo;
-(void)packageDailyInfo;

//Time Manage
-(void)recountViewTime;
-(void)checkVersion;

//Register methods:
-(void)registerLT:(NSString *)name; //Can Get Time
-(void)registerEX:(NSString *)name with:(NSString *)exName happensin:(double)seconds;
-(void)registerGR:(NSString *)name;

-(void)sendOutData;
@end
