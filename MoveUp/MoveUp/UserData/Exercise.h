//
//  Exercise.h
//  TestUI
//
//  Created by Ye Ke on 1/10/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Part.h"
@interface Exercise : NSObject {
    
    NSString * exName;
    Part * part;  //Related Part
    int exNum;
    NSDate * lastdoDate;
    NSMutableDictionary * log;
    
    Boolean hasIndication;
    NSString * i_Description;
    NSString * i_ImagePath;
    NSString * i_SoundPath;
    float startSec;
    
    NSString * videoPath;
    NSString * content;
    NSString * title;
}

@property(nonatomic, assign) Boolean hasIndication;
@property(nonatomic, retain) NSString * i_Description;
@property(nonatomic, retain) NSString * i_ImagePath;
@property(nonatomic, retain) NSString * videoPath;
@property(nonatomic, assign) float startSec;
@property(nonatomic, assign) int exNum;
@property(nonatomic, retain) Part * part;
@property(nonatomic, retain) NSDate * lastdoDate;
@property(nonatomic, retain) NSString * exName;
@property(nonatomic, retain) NSString * i_SoundPath;
@property(nonatomic, retain) NSString * content;
@property(nonatomic, retain) NSString * title;

-(NSMutableDictionary *)saveToDecitonary;
-(void)loadFromDictionary:(NSMutableDictionary *)tlog;
+(NSMutableArray *)readFromPLIST:(NSDictionary *)info with:(NSString *)partName;
-(void)printInfo;
-(BOOL)moveDoc;


@end
