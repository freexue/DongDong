//
//  ExerciseBehavior.m
//  TestUI
//
//  Created by Ye Ke on 1/5/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "ExerciseBehavior.h"
#import "UserData.h"

@implementation ExerciseBehavior

@synthesize extraInfo;
@synthesize ExName;
@synthesize ExTime;

-(NSMutableDictionary *)saveToDecitonary {
    
    if (log == nil) {
        log = [[NSMutableDictionary alloc]init];
    }
    
    [log setObject:name forKey:@"Name"];
    [log setObject:type forKey:@"Type"];  
    [log setObject:ToString(timeStamp) forKey:@"TimeStamp"];
    [log setObject:[UserData sharedUser].ID forKey:@"ID"];
    [log setObject:[NSNumber numberWithDouble: ExTime] forKey:@"ExTime"];
    [log setObject:ExName forKey:@"ExName"];
    
    if (!extraInfo) {
        extraInfo = @"";
    }
    [log setObject:extraInfo forKey:@"ExtraInfo"];
    return log;
}

-(Behavior *)loadFromDictionary:(NSMutableDictionary *)tlog {
    
    type = [tlog objectForKey:@"Type"];
    name = [tlog objectForKey:@"Name"];
    //timeStamp = [tlog objectForKey:@"TimeStamp"];
    
    ExTime = [[tlog objectForKey:@"ExTime"] doubleValue];
    ExName = [tlog objectForKey:@"ExName"];
    extraInfo = [tlog objectForKey:@"ExtraInfo"];
    log = tlog;
    
    return self;
}


-(void)printInfo {
    
    NSLog(@"--------Behavior--------");
    
    NSLog(@"name: %@", name);
    NSLog(@"type: %@", type);
    NSLog(@"date: %@", timeStamp);
    NSLog(@"exName: %@", ExName);
    NSLog(@"exTime: %f", ExTime);
    NSLog(@"extraInfo %@",extraInfo);
    
    NSLog(@"------------------------\n");
    
}

@end
