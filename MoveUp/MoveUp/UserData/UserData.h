//
//  UserData.h
//  TestUI
//
//  Created by Ke Ye on 8/8/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SystemConfig.h"
#import "Behavior.h"
#import "Sympthon.h"
#import "Part.h"
#import "Exercise.h"
#define kMALE 1
#define kFEMALE 0

#define kNo 0
#define kTicked 1
#define kPotential 2 

typedef enum{
    JUSTADDED,
    NORMAL,
    FROMSTART,
}StartStatus;

@interface UserData : NSObject {
    
    int neck;  
    int back;
    int waist;
    int finger;
    int wrist;
    int elbow; //wrist and elbow becomes one part
    int butt;
    int leg;
    int head;
    int shoulder;
    
    //------------------Abandonned Infos
    NSString * noti1Time;  //Abandonned
    NSString * noti2Time;  //Abandonned, replaced as an Array
    
    NSMutableArray * achievements;  //Abandonned 
    
    int medal;    //Abandonned
    int sittingTime;  //Abandonned
    int compTime;  //Abandonned
    
    int insistDays;  //Abandonned
    int insistWeeks;  //Abandonned
  
    int prohibit;  //0 -> 5days, 1 -> 7days
    
    //--------------------From Here is the New Datasets
    
    Boolean gender;            //0For FM, 1For M
    int age;
    NSMutableArray * parts;    //LIST For Parts
    NSMutableArray * behaviors; //LIST For Behavvior
    NSMutableArray * sympthons;
    NSMutableArray * exercises; //Exercise Class Array
    
    int exDaysNum;  //Accumulated Ex Days
    NSDate * lastdt; //Last NSDate Open Dongdong
    NSDate * lastFinishDt; 
    float progress;   //0~Infinity
    float fitRate;    //0~100
    
    NSString * ID;
    double sympthonFactor; //Used to represent sympthon answers as answer_num-digits number
    NSDate * regstrTime;
    NSString * weiboName;
    
    int notiFactor;  //To Record From Monday to Tuesday
    NSMutableArray * notiArr;  //Record Noti Times, like 14:00 to 1400
    NSMutableArray * quizData;
    NSMutableArray * weekDays;
    
    StartStatus startStatus;
    
    NSString * token;
}

@property(nonatomic, retain) NSString * token;
@property(nonatomic, assign) StartStatus startStatus;
@property(nonatomic, assign) int insistDays;
@property(nonatomic, assign) int insistWeeks;
@property(nonatomic, assign) int prohibit;

@property(nonatomic, assign) int neck;
@property(nonatomic, assign) int back;
@property(nonatomic, assign) int waist;
@property(nonatomic, assign) int finger;
@property(nonatomic, assign) int wrist;
@property(nonatomic, assign) int elbow;
@property(nonatomic, assign) int butt;
@property(nonatomic, assign) int leg;
@property(nonatomic, assign) int head;
@property(nonatomic, assign) int shoulder;

@property(nonatomic, retain) NSDate * lastdt;

@property(nonatomic, assign) Boolean gender;
@property(nonatomic, retain) NSString * noti1Time;
@property(nonatomic, retain) NSString * noti2Time;
@property(nonatomic, retain) NSMutableArray * achievements;
@property(nonatomic, assign) int medal;
@property(nonatomic, assign) int sittingTime;
@property(nonatomic, assign) int compTime;

//--------------------------------------------

@property(nonatomic, retain) NSMutableArray * behaviors;
@property(nonatomic, retain) NSMutableArray * parts;
@property(nonatomic, retain) NSMutableArray * sympthons;
@property(nonatomic, retain) NSString * ID;
@property(nonatomic, assign) int age;
@property(nonatomic, assign) double sympthonFactor;
@property(nonatomic, retain) NSDate * regstrTime;
@property(nonatomic, retain) NSString * weiboName;
@property(nonatomic, retain) NSMutableArray * notiArr;
@property(nonatomic, assign) int notiFactor;
@property(nonatomic, assign) float fitRate;
@property(nonatomic, assign) int exDaysNum;
@property(nonatomic, retain) NSMutableArray * quizData;
@property(nonatomic, retain) NSMutableArray * weekDays;
@property(nonatomic, assign) float progress;
@property(nonatomic, retain) NSMutableArray * exercises;
@property(nonatomic, retain)  NSDate * lastFinishDt;



-(void)resetUser;
-(void)importUser;
-(void)exportUser;
-(void)setPart:(NSString *)part with:(int)value;
-(int)getPart:(NSString *)part;
+(UserData *)sharedUser;
-(void)printPersonalInfo;
-(NSString *)getPartName:(NSString *)ex;
-(void)updateInsistDate;
-(int)isWinningAchievement;
-(void)setPotentials;

//----------------New functions
-(void) setPartsFrom:(NSMutableArray *)symp; //Set Sympthons at the Same Time
//According To the body condition, make health curve, according to progress, calculate the fit rate
-(void) updateFitRate;
-(void) updateExDaysNum;
-(void) addProgress;
//According to the day diffrence between now and last exercised time as basic input
//time: format like 13:31
//weekday: @"MONDAY"...

//Important:Check ID exists or not
-(Boolean) checkID;
-(void) createID;
-(void) registerTime;
@end
