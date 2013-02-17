//
//  LongTermBehavior.h
//  TestUI
//
//  Created by Ye Ke on 1/5/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "Behavior.h"

@interface LongTermBehavior : Behavior {
    //TYPE: LONGTERM
    //NAME: ASSES, PLAY, TEXT, SETTING, TIPS
    //
    double viewTime;
}

@property(nonatomic, assign) double viewTime;

-(NSMutableDictionary *)saveToDecitonary;
-(LongTermBehavior *)loadFromDictionary:(NSMutableDictionary *)tlog;
-(void)printInfo;

@end
