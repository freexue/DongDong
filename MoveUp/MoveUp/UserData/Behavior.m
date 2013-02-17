//
//  Behavior.m
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "Behavior.h"
#import "UserData.h"

@implementation Behavior
@synthesize name;
@synthesize type;
@synthesize timeStamp;
@synthesize log;

-(NSMutableDictionary *)saveToDecitonary {
    
    if (log == nil) {
        log = [[NSMutableDictionary alloc]init];
    }
        [log setObject:name forKey:@"Name"];
        [log setObject:type forKey:@"Type"]; 
        [log setObject:ToString(timeStamp) forKey:@"TimeStamp"];
        [log setObject:[UserData sharedUser].ID forKey:@"ID"];
    
    return log;
}

-(Behavior *)loadFromDictionary:(NSMutableDictionary *)tlog {

    name = [tlog objectForKey:@"Name"];
    type = [tlog objectForKey:@"Type"];
    //timeStamp = [tlog objectForKey:@"TimeStamp"];
    log = tlog;
    return self;
}

-(void)printInfo {
    
    NSLog(@"--------Behavior--------");
    
    NSLog(@"name: %@", name);
    NSLog(@"type: %@", type);
    NSLog(@"date: %@", timeStamp);
    
    NSLog(@"------------------------\n");
    
}

@end
