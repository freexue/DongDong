//
//  GeneralBehavior.h
//  TestUI
//
//  Created by Ye Ke on 1/5/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "Behavior.h"

@interface ExerciseBehavior : Behavior {
    //TYPE: EXERCISE
    //NAME: QUIT, POPUP, TEXT, DRAG, FINISH, CANCEL, START,
    NSString * extraInfo;
    NSString * ExName;
    double ExTime;
}
@property(nonatomic, retain) NSString * extraInfo;
@property(nonatomic, retain) NSString * ExName;
@property(nonatomic, assign) double ExTime;

-(NSMutableDictionary *)saveToDecitonary;
-(ExerciseBehavior *)loadFromDictionary:(NSMutableDictionary *)tlog;
-(void)printInfo;

@end
