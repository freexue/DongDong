//
//  UserPartModel.h
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserConfig.h"

@interface Part : NSObject {
    NSString * name;
    ConditionType conditiontype;
    BodyStat status;
    NSDate * lastExtime;   //Set Now When Initialized
    int exercisedNum;  //Time of exercise in certain time
    float rawData;   //Store scores caculated from answers, to set ConditionType and BodyStat
    int numToNext;   //Time of exercise needed to next level
    NSMutableDictionary * log;
}

@property(nonatomic, retain) NSString * name;
@property(nonatomic, assign) ConditionType conditiontype;
@property(nonatomic, assign) BodyStat status;
@property(nonatomic, retain) NSDate * lastExtime;
@property(nonatomic, assign) float rawData;
@property(nonatomic, assign) int exercisedNum;
@property(nonatomic, assign) int numToNext;


-(NSMutableDictionary *)saveToDecitonary;
-(Part *)loadFromDictionary:(NSMutableDictionary *)tlog;
-(void)printInfo;
-(id)init;
-(void)updateAfterEx;
-(void)update;
+(int)calculatePartsFactor;
+(Part *)getPart:(NSString *)partName;

@end
