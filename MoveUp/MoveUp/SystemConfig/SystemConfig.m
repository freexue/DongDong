//
//  SystemConfig.m
//  TestUI
//
//  Created by Ye Ke on 12/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "SystemConfig.h"

@implementation SystemConfig

+(Boolean)isIphone5{
    NSLog(@"UIScreen mainScreen].bounds.size.height %f",[UIScreen mainScreen].bounds.size.height);
    Boolean isIphone5 = ([UIScreen mainScreen].bounds.size.height == 568 )?YES:NO;
    return isIphone5;
}

+(float)getVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [[infoDictionary objectForKey:@"CFBundleShortVersionString"]floatValue];
}

/**
 isJustUpdated: Check updating.
 NOTE: Since key "version" is used from 2.0, it may or maynot be used according the last version of user. Both situations should be disposed of.
 */
+(Boolean)isJustUpdated{
    
    float storedVersion = [[NSUserDefaults standardUserDefaults] floatForKey:@"version"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    float appCurVersion = [[infoDictionary objectForKey:@"CFBundleShortVersionString"]floatValue];
    
    if(appCurVersion > storedVersion)
    {
     
        return YES;
    }
    return NO;
}

+(void)setNeedUpdateStatus:(BOOL)status {
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"needUpdate"];
}

+(Boolean)needRemindUpdate {
    
    BOOL need = [[NSUserDefaults standardUserDefaults] boolForKey:@"needUpdate"];
    if (need) {
        
        int chance = arc4random()%30;
        NSLog(@"Chance============--------=============------ %d", chance);
        if (chance <= 10) {
            return YES;
        }
        else return NO;
    }
    return NO;
}

@end
