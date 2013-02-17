//
//  NotificationManager.h
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserConfig.h"
#import "UserData.h"

//Notification Infos Collection

NSMutableArray * NOTIINFOS;
typedef enum {
    SUNDAY = 1,
    MONDAY = 2,
    TUESDAY = 3,
    WEDNESDAY = 4,
    THURSDAY = 5,
    FRIDAY = 6,
    SATURDAY = 7,
}WEEKDAY;


@interface NotificationManager : NSObject {
   
}

+ (void)registerRegularNotification: (int)hh and: (int) mm of: (WEEKDAY)weekday;
+ (void)registerOneTimeNotification: (int)hh and: (int) mm after:(NSDate *)date;
+ (void)cancelNotifiction:(NSString *)notiType;
+ (void)clearOldNotifications;
+ (NSString *)weekDayForIndex:(int)index;
+ (void)resetNotifications;

- (void)registerRemoteNotification;
@end
