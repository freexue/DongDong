//
//  UserPartModel.m
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "Part.h"
#import "UserData.h"

@implementation Part
@synthesize name;
@synthesize status;
@synthesize conditiontype;
@synthesize lastExtime;
@synthesize rawData;
@synthesize exercisedNum;
@synthesize numToNext;

-(id)init {
    if (self = [super init]) {
        [UserConfig config]; //Initialize Config
        lastExtime = [NSDate distantPast];
    }
    return self;
}


-(NSMutableDictionary *)saveToDecitonary {
    
    if (log == nil) {
        log = [[NSMutableDictionary alloc]init];
    }
    [log setObject:name forKey:@"name"];
    [log setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [log setObject:[NSNumber numberWithInt:conditiontype] forKey:@"conditiontype"];
    [log setObject:lastExtime forKey:@"lastextime"];
    [log setObject:[NSNumber numberWithInt:exercisedNum] forKey:@"exercisedNum"];
    [log setObject:[NSNumber numberWithInt:numToNext] forKey:@"numToNext"];
        
    return log;
}

-(Part *)loadFromDictionary:(NSMutableDictionary *)tlog {
    
    name = [tlog objectForKey:@"name"];
    status = [[tlog objectForKey:@"status"] intValue];
    conditiontype = [[tlog objectForKey:@"conditiontype"] intValue];
    lastExtime = [tlog objectForKey:@"lastextime"];
    exercisedNum = [[tlog objectForKey:@"exercisedNum"] intValue];
    numToNext = [[tlog objectForKey:@"numToNext"] intValue];
    
    return self;
}

-(void)printInfo {
    
    NSLog(@"----------PART-----------");
    NSLog(@"name: %@", name);
    NSLog(@"status %@", [UserConfig config].STATUS[status]);
    NSLog(@"conditiontype %@", [UserConfig config].CTYPE[conditiontype]);
    NSLog(@"rawData %f", rawData);
    NSLog(@"exercisedNum %d",exercisedNum);
    NSLog(@"------------------------\n");
}

-(void)updateAfterEx {
    exercisedNum ++;
    numToNext ++;
    lastExtime = [NSDate new];
    [self update];
}


/**
 Update:
 NOTE: GO TO DOWN LEVEL, ONLY ONE LEVEL AT A TIME;
 */
-(void)update { //Update STATUS mainly
    int needDays = 0;
    int undoDays = 0;
    if (conditiontype == ORDINARY) {
        
        if (status  > GOOD) { //Go To Up Level
            needDays = ORDINARY_MT[status][status - 1];
            if (needDays <= numToNext) {
                status --;
                numToNext = 0;
            }
        }

        if (status < BAD) { //Go To Down Level
            undoDays = ORDINARY_MT[status][status + 1];
            int days = [[UserConfig config] dayDifference:lastExtime to:[NSDate new]];
            if (days >= undoDays) {
                status ++;
                lastExtime = [NSDate new]; //Calculate Again
                numToNext = 0;
            }

        }
    }

    else if (conditiontype == POTENTIAL) {
     
        if (status  >GOOD) { //Go To Up Level
            
            needDays = POTENTIAL_MT[status][status - 1];
            if (needDays <= numToNext) {
                status --;
                numToNext = 0;
            }
        }
        
        if (status < BAD) { //Go To Down Level
            
            undoDays = POTENTIAL_MT[status][status + 1];
            int days = [[UserConfig config] dayDifference:lastExtime to:[NSDate new]];
            if (days >= undoDays) {
                status ++;
                lastExtime = [NSDate new]; //Calculate Again
                numToNext = 0;
            }
        }
    }
    
    else if (conditiontype == HURT) {
     
        if (status  > GOOD) { //Go To Up Level
            
            needDays = HURT_MT[status][status - 1];
            if (needDays <= numToNext) {
                status --;
                numToNext = 0;
            }
        }
        
        if (status < BAD) { //Go To Down Level
            
            undoDays = HURT_MT[status][status + 1];
            int days = [[UserConfig config] dayDifference:lastExtime to:[NSDate new]];
            if (days >= undoDays) {
                status ++;
                lastExtime = [NSDate new]; //Calculate Again
                numToNext = 0;
            }
        }
    }
}

+(int)calculatePartsFactor {
    
    int statusSet = 0;
    for (Part * pt in [UserData sharedUser].parts) {
        statusSet +=  pt.status;
        statusSet *=10;
    }
    return statusSet;
}

+(Part *)getPart:(NSString *)partName {
    for (Part * pt in [UserData sharedUser].parts) {
        if ([pt.name isEqualToString:partName]) {
            return pt;
        }
    }
    return nil;
}

@end
