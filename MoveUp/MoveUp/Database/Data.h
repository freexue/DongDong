//
//  Data.h
//  TestUI
//
//  Created by FreeXue on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"
#import "actionCount.h"
@interface Data : NSObject{
    
    int _id;
    NSString  *date;
    Boolean  head_1;   
    Boolean  head_2; 
    Boolean  head_3; 
    Boolean  head_4; 
    Boolean  wrist_1;
    Boolean  finger_1;
    Boolean  finger_2;
    Boolean  elbow_1;
    Boolean  elbow_2;
    Boolean  neck_1;
    Boolean  neck_2;
    Boolean  neck_3;
    Boolean  shoulder_1;
    Boolean  shoulder_2;
    Boolean  back_1;
    Boolean  back_2;
    Boolean  waist_1;
    Boolean  waist_2;
    Boolean  waist_3;
    Boolean  leg_1;
    Boolean  leg_2;
    Boolean  leg_3;
    Boolean  butt_1;

}



@property (nonatomic, assign) int  _id;
@property (nonatomic, retain) NSString  *date;
@property (nonatomic, assign) Boolean  head_1;   
@property (nonatomic, assign) Boolean  head_2; 
@property (nonatomic, assign) Boolean  head_3; 
@property (nonatomic, assign) Boolean  head_4; 
@property (nonatomic, assign) Boolean  wrist_1;
@property (nonatomic, assign) Boolean  finger_1;
@property (nonatomic, assign) Boolean  finger_2;
@property (nonatomic, assign) Boolean  elbow_1;
@property (nonatomic, assign) Boolean  elbow_2;
@property (nonatomic, assign) Boolean  neck_1;
@property (nonatomic, assign) Boolean  neck_2;
@property (nonatomic, assign) Boolean  neck_3;
@property (nonatomic, assign) Boolean  shoulder_1;
@property (nonatomic, assign) Boolean  shoulder_2;
@property (nonatomic, assign) Boolean  back_1;
@property (nonatomic, assign) Boolean  back_2;
@property (nonatomic, assign) Boolean  waist_1;
@property (nonatomic, assign) Boolean  waist_2;
@property (nonatomic, assign) Boolean  waist_3;
@property (nonatomic, assign) Boolean  leg_1;
@property (nonatomic, assign) Boolean  leg_2;
@property (nonatomic, assign) Boolean  leg_3;
@property (nonatomic, assign) Boolean  butt_1;


//method of data
+(void) emptytable;
-(void) insertRecord;
+ (actionCount *) countEachAction;
+(NSString *) recentfinish;
-(NSMutableArray *) leastdo:(NSArray *)condition num:(int)num;
+(NSDictionary *)showCheckpoint;
+(NSMutableArray *)initDic;
-(void)setstatus:(NSString *)position;
+(Boolean)getstatus;
@end
