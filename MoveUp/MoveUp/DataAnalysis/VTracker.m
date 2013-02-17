//
//  VTracker.m
//  TestUI
//
//  Created by Ye Ke on 1/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "VTracker.h"
#import "SystemConfig.h"
#define CHECKVERSION 117

VTracker * publictacker;
/**
 
 VTracker: Data Transmission Module;
 1.Package All NSDictionary/NSArray Into Json
 2.Transmitt Them
 
 Number of Trasmission Methods are based on THINKPHP Server
 */
@implementation VTracker

+(VTracker *)tracker {
    if(publictacker == nil) {
        publictacker = [[VTracker alloc]init];
    }
    return publictacker;
}

-(id)init{
    
    if (self = [super init]) {
        
        networkQueue = [[ASINetworkQueue alloc]init];
        networkQueue.delegate = self;
        networkQueue.queueDidFinishSelector = @selector(queueFinished:);
        networkQueue.requestDidFinishSelector = @selector(requestFinished:);
        networkQueue.requestDidFailSelector = @selector(requestFailed:);
        
        viewTime = [NSDate date];
        sessionTime = [NSDate date];
    }
    return self;
}

-(void)checkVersion {
    
        NSString * urlStr = [NSString stringWithFormat:@"%@%@%@",IP,Directory,@"TokenManage/version"];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.tag = CHECKVERSION;
        [networkQueue addOperation:request];
}

-(void)addRequestToQueue:(id)info toAccess:(NSString *)webAcc JSONED:(Boolean)ifneed {
    
    HTTPTrackRequest * t_request = [[HTTPTrackRequest alloc]init];
    NSString * url = [NSString stringWithFormat:@"%@%@%@",IP,Directory,webAcc];
    
    NSLog(@"URL %@", url);
    
    ASIFormDataRequest * request;
    
    if (!ifneed) {
        request =  [t_request packageRequest:url withData:info];
        
    }
    else {
        
        
        NSString * params = [self encodeInfo:info];
        NSLog(@"Encoded JSON String: %@", params); 
        
        NSDictionary * paramDic = [NSDictionary dictionaryWithObject:params forKey:@"info"];
        
        request =  [t_request packageRequest:url withData:paramDic];
       
    }
    
    [networkQueue addOperation:request];
}



#pragma mark Package Methods
-(void)packageUerInfo {
    
    NSString * Id = [UserData sharedUser].ID; //Got
    NSString * WeiboName = [UserData sharedUser].weiboName; //How to get is missing
    if (!WeiboName) {
        //WeiboName = @"-";
    }
    
    WeiboName = @"M_10";
    
    NSString * RegstTime = ToString([UserData sharedUser].regstrTime); //Got
    double SymFac = [UserData sharedUser].sympthonFactor; //Level means serve standard, 0,3,4,9//
    int Gender = [UserData sharedUser].gender?1:0;  //Got
    int Age = [UserData sharedUser].age;  //Got
    NSMutableArray * NotiArr = [UserData sharedUser].notiArr; //How to get is missing
    int NotiFactor = [UserData sharedUser].notiFactor; //How to get is missing
    NSString * token = [UserData sharedUser].token;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    if (token) {
        [dic setObject:token forKey:@"Token"];
    }
    else {
        [dic setObject:@"Empty" forKey:@"Token"];
    }
    
    float version = [SystemConfig getVersion];
    
    [dic setObject:[NSNumber numberWithFloat:version] forKey:@"Version"];
    [dic setObject:Id forKey:@"ID"];
    [dic setObject:WeiboName forKey:@"WeiboName"];
    [dic setObject:RegstTime forKey:@"RegstTime"];
    [dic setObject:[NSNumber numberWithDouble:SymFac] forKey:@"SymFac"];
    [dic setObject:[NSNumber numberWithInt:Age] forKey:@"Age"];
    [dic setObject:[NSNumber numberWithInt:NotiFactor] forKey:@"NotiFactor"];
    [dic setObject:NotiArr forKey:@"Notis"];
    [dic setObject:[NSNumber numberWithInt:Gender] forKey:@"Gender"];
    
    [self addRequestToQueue:dic toAccess:@"Index/insert" JSONED:YES];
    
    [dic release];
}

-(void)packageDailyInfo {
    
    NSString * Id = [UserData sharedUser].ID;
    float FitRate = [UserData sharedUser].fitRate;
    int ExDaysNum = [UserData sharedUser].exDaysNum;
    int PartFactor = [Part calculatePartsFactor];

    NSDate * dt = [[NSDate date] dateByAddingTimeInterval: 60 * 60 * 8];
    NSString * timeStamp = ToString(dt);
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:Id forKey:@"Id"];
    [dic setObject:timeStamp forKey:@"TimeStamp"];
    [dic setObject:[NSNumber numberWithInt:PartFactor] forKey:@"PartFactor"];
    [dic setObject:[NSNumber numberWithFloat:FitRate] forKey:@"FitRate"];
    [dic setObject:[NSNumber numberWithInt:ExDaysNum] forKey:@"ExDaysNum"];
    
    [self addRequestToQueue:dic toAccess:@"DailyInfo/insert" JSONED:YES];
    [dic release];
    //All Part Status
}

-(void)packageBehaviors {
    
    NSMutableArray * logs = [[NSMutableArray alloc]init];
    
    if ([UserData sharedUser].behaviors != nil) {
        
        for (Behavior * bh in [UserData sharedUser].behaviors) {
            
            NSLog(@"PackageBehaviors: %@",[bh.log JSONString]);
            [logs addObject:bh.log];
            NSLog(@"Logs: %@",[logs JSONString]);
        }        
        [self addRequestToQueue:logs toAccess:@"Behavior/insertQueue" JSONED:YES];
    }
    [[UserData sharedUser].behaviors removeAllObjects];
    [logs release];
}

#pragma mark Time Management

-(void)recountViewTime {
    viewTime = [NSDate new];
}




-(void)sendOutData{
    [networkQueue go];
    //[networkQueue reset];
}

//Data Encoding and Decoding
-(NSString *)encodeInfo:(id)info {
    return [info JSONString];
}
-(NSDictionary *)decodeInfo:(NSData *)data {
    //
    return nil;
}

#pragma mark Behavior Register Methods

-(void)registerLT:(NSString *)name {
    
    LongTermBehavior * behavior = [[LongTermBehavior alloc]init];
    behavior.name = name;
    behavior.type = @"LongTerm";
    behavior.viewTime = [NSDate timeIntervalSinceReferenceDate] - [viewTime timeIntervalSinceReferenceDate];
    behavior.timeStamp = [NSDate date];
    behavior.timeStamp = [behavior.timeStamp dateByAddingTimeInterval: 60 * 60 * 8];
    [behavior saveToDecitonary];
    
    [[UserData sharedUser].behaviors addObject:behavior];
    [behavior release];
}

-(void)registerEX:(NSString *)name with:(NSString *)exName happensin:(double)seconds {
    
    ExerciseBehavior * exbh = [[ExerciseBehavior alloc]init];
    exbh.name = name;
    exbh.type = @"Exercise";
    exbh.timeStamp = [NSDate date];
    exbh.timeStamp = [exbh.timeStamp dateByAddingTimeInterval: 60 * 60 * 8];
    exbh.ExTime = seconds;
    exbh.ExName = exName;
    [exbh saveToDecitonary];
    
    [[UserData sharedUser].behaviors addObject:exbh];
    [exbh release];
}

-(void)registerGR:(NSString *)name {
    
    Behavior * behavior = [[Behavior alloc]init];
    behavior.name = name;
    behavior.type = @"General";
    behavior.timeStamp = [NSDate date];
    behavior.timeStamp = [behavior.timeStamp dateByAddingTimeInterval:60 * 60 *8];
    [behavior saveToDecitonary];
    
    [[UserData sharedUser].behaviors addObject:behavior];
    [behavior release];
}

#pragma mark NetworkQueue delegate

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString * responseString = [request responseString];
    NSLog(@"%@",responseString);
    NSLog(@"QueueRequestFinished");
    
    if (request.tag == CHECKVERSION) {
        NSString * responseString = [request responseString];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        float version = [responseString floatValue];
        if (version > [SystemConfig getVersion]) {
            [SystemConfig setNeedUpdateStatus:YES];
        }
        else {
            [SystemConfig setNeedUpdateStatus:NO];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    
    NSError * error = [request error];
    NSLog(@"%@",error.description);
    NSLog(@"QuueRequestFailed");
}

- (void)queueFinished:(ASINetworkQueue *)queue {
    NSLog(@"QueueFinished");
}


@end
