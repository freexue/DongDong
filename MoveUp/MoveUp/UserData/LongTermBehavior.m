//
//  LongTermBehavior.m
//  TestUI
//
//  Created by Ye Ke on 1/5/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "LongTermBehavior.h"
#import "UserData.h"

@implementation LongTermBehavior
@synthesize viewTime;

-(NSMutableDictionary *)saveToDecitonary {
    
    if (log == nil) {
        log = [[NSMutableDictionary alloc]init];
    }
    [log setObject:name forKey:@"Name"];
    [log setObject:type forKey:@"Type"];  //LONGTERM
    [log setObject:ToString(timeStamp) forKey:@"TimeStamp"];
    [log setObject:[NSNumber numberWithDouble:viewTime] forKey:@"ViewTime"];
    [log setObject:[UserData sharedUser].ID forKey:@"ID"];
    
    return log;
}

-(LongTermBehavior *)loadFromDictionary:(NSMutableDictionary *)tlog {
    
    type = [tlog objectForKey:@"Type"];
    name = [tlog objectForKey:@"Name"];
    //timeStamp = [tlog objectForKey:@"TimeStamp"];
    viewTime = [[tlog objectForKey:@"ViewTime"] doubleValue];
    log = tlog;
    return self;
}


-(void)printInfo {
    
    NSLog(@"--------Behavior--------");
    
    NSLog(@"name: %@", name);
    NSLog(@"type: %@", type);
    NSLog(@"date: %@", timeStamp);
    NSLog(@"viewTime %f", viewTime);
    
    NSLog(@"------------------------\n");
    
}

@end
