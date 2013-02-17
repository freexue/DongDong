//
//  UserConfig.m
//  TestUI
//
//  Created by Ye Ke on 1/3/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "UserConfig.h"
UserConfig * publicConfig;

@implementation UserConfig
@synthesize CTYPE;
@synthesize STATUS;

+(UserConfig *)config {
    if (publicConfig == nil) {
        publicConfig = [[UserConfig alloc]init];
    }
    return publicConfig;
}

-(id)init {
    if (self = [super init]) {
        self.STATUS = @[@"GOOD",
                   @"COMMON",
                   @"MEDIUM",
                   @"BAD"];
        
        self.CTYPE = @[@"HURT",
                  @"POTENTIAL",
                  @"ORDINARY"];
        
        
        for (int i =0; i < 4; i++) {
            for (int j = 0; j < 4; j ++) {
                ORDINARY_MT[i][j] = 1000;
                POTENTIAL_MT[i][j] = 1000;
                HURT_MT[i][j] = 1000;
            }
        }
        
        ORDINARY_MT[0][1] = 4;
        ORDINARY_MT[1][0] = 2;
        
        POTENTIAL_MT[0][1] = 5;
        POTENTIAL_MT[1][0] = 5;
        POTENTIAL_MT[1][2] = 3;
        POTENTIAL_MT[2][1] = 3;
        
        HURT_MT[1][2] = 4;
        HURT_MT[2][1] = 6;
        HURT_MT[2][3] = 2;
        HURT_MT[3][2] = 2;
        
        TYPEVALUE[0] = 0;
        TYPEVALUE[1] = 4;
        TYPEVALUE[2] = 8;
        
        STATUSVALUE[3] = 0;
        STATUSVALUE[2] = 4;
        STATUSVALUE[1] = 8;
        STATUSVALUE[0] = 10;
        
    }
    return self;
}

/**
 dayDifference: Get day difference
 */
-(int)dayDifference:(NSDate *)beginDate to: (NSDate *)endDate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString * dateString1 =[formatter stringFromDate:beginDate];
    NSString * dateString2 =[formatter stringFromDate:endDate];
    
    NSDate * modi1 = [formatter dateFromString:dateString1];
    NSDate * modi2 = [formatter dateFromString:dateString2];
    
    [formatter release];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlag = NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:modi1 toDate:modi2 options:0];
    
    [calendar release];
    
    int days = [components day];
    return days;
}

@end
