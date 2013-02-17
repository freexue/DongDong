//
//  UserConfig.h
//  TestUI
//
//  Created by Ye Ke on 1/3/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>

int ORDINARY_MT[4][4];
int POTENTIAL_MT[4][4];
int HURT_MT[4][4];
int TYPEVALUE[3];
int STATUSVALUE[4];

typedef enum{
    GOOD = 0,
    COMMON = 1,
    MEDIUM = 2,
    BAD = 3,
}BodyStat;

//ORDINARY: CANNOT BE UNDER COMMON easy to be GOOD, hard to turn back
//POTENTIAL: CAN BE TO GOOD low worsen rate
//HART: CAN BE COMMON, high worsen rate


/**
 1.According to the answers, get conditionType of each part.
 2.According to the conditionType, the curve of different conditionType is different.
 
 
 ROW -> COLUMN: FROM STATE OF THIS ROW TO STATE OF COLUMN
 
 ORDINARY:       GOOD COMMON MEDIUM BAD (Days/Times Consider Turning Worse or Turning Better)
 GOOD             -     4    -       -
 COMMON           2     -    -       -
 MEDIUM           -     -    -       -
 BAD              -     -    -       -
 
 POTENTIAL:      GOOD COMMON MEDIUM BAD
 GOOD             -     5    -       -
 COMMON           5     -    3       -
 MEDIUM           -     3    -       -
 BAD              -     -    -       -
 
 HURT:           GOOD COMMON MEDIUM BAD
 GOOD             -     -    -       -
 COMMON           -     -    4       -
 MEDIUM           -     6    -       2
 BAD              -     -    2       -
 
 */

typedef enum{
    ORDINARY = 2, // -> COMMON
    POTENTIAL = 1, // -> MEDIUM
    HURT = 0, // -> BAD
}ConditionType;

@interface UserConfig : NSObject {
    NSArray* STATUS;
    NSArray* CTYPE;
}

@property (nonatomic, retain) NSArray* STATUS;
@property (nonatomic, retain) NSArray* CTYPE;

+(UserConfig *)config;
-(int)dayDifference:(NSDate *)beginDate to: (NSDate *)endDate;
@end
