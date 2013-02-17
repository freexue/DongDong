//
//  Behavior.h
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ToString(Date) [[NSString stringWithFormat:@"%@",Date]substringToIndex:19]

@interface Behavior : NSObject {
    //NAME: NOTI_FAIL, NOTI_SUCCESS, NOTI_DELAY, RESETINFO, DELETE, SHARE
    NSString * type; 
    NSString * name;
    NSDate * timeStamp;
    NSMutableDictionary * log; //Decode <-> Encode
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSMutableDictionary * log;

-(NSMutableDictionary *)saveToDecitonary;
-(Behavior *)loadFromDictionary:(NSMutableDictionary *)tlog;
-(void)printInfo;

@end
