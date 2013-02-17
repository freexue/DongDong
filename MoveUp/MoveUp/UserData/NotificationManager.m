//
//  NotificationManager.m
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager


+ (void)registerRegularNotification: (int)hh and: (int) mm of: (WEEKDAY)weekday {
    
    //WeekDay
    /*
    1:Sunday
     ...
    7:Saturday
    */
    //1.获得当天的推送时间
    NSDate* now = [NSDate date];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
	NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	comps = [calendar components:unitFlags fromDate:now];
    
    
    //2.根据当天是星期几，而推送时间是星期几，计算出增加的天数，算出推送时间；
    
    int nowweekday = [comps weekday];
    int hm = (hh - [comps hour] ) * 3600 + (mm - [comps minute]) * 60 - [comps second];
    int dayDiff = (weekday - nowweekday + 7) % 7;

    if (hm <0 && dayDiff == 0) {
        dayDiff = 7;
    }
    
    //-----------------－－－－－－－－－－－－－－－－－－－－－－－－－－－取得系统的时间，并将其一个个赋值给变量－－－－－－－－－－－－－－－－－－－－－
    
    
    NSLog(@"HM %d", hm);
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now = [NSDate new];
        NSDate *firedt = [now dateByAddingTimeInterval: dayDiff * 60 * 60 * 24 + hm];
        NSCalendar *calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps2 = [[NSDateComponents alloc] init];
        NSInteger unitFlags2 = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        comps2 = [calendar2 components:unitFlags2 fromDate:firedt];
        
        notification.fireDate= [now dateByAddingTimeInterval: dayDiff * 60 * 60 * 24 + hm]; //设置响应时间,单位 秒
        notification.timeZone=[NSTimeZone systemTimeZone];
        NSString * Stype = [NSString stringWithFormat:@"%@",[self weekDayForIndex:weekday]];
        
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:Stype,@"Type",nil];
        notification.userInfo = dic;
        notification.alertBody = [NSString stringWithFormat:@"做操时间到啦"];
        notification.repeatInterval = NSWeekCalendarUnit;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


+ (void)clearOldNotifications {
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

+ (void)registerOneTimeNotification: (int)hh and: (int) mm after:(NSDate *)date {
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        
        notification.fireDate=[date dateByAddingTimeInterval:(hh * 3600 + mm * 60)]; //设置响应时间,单位 秒
        notification.timeZone=[NSTimeZone systemTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        NSDictionary * dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"Extra",@"Type",nil];
        notification.userInfo = dic;
        notification.alertBody = [NSString stringWithFormat:@"做操时间到啦"];
        
        notification.repeatInterval = NSDayCalendarUnit;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}

+ (void)cancelNotifiction:(NSString *)notiType {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"Type"]];
        
        if ([uid isEqualToString:notiType])
        {
            //Cancelling local notification
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

+ (NSString *)weekDayForIndex:(int)index {
    
    NSArray * weekday = @[@"SUNDAY",@"MONDAY",@"TUESDAY",@"WEDNESDAY",@"THURSDAY",@"FRIDAY",@"SATURDAY",];
    return weekday[index - 1];
}

+ (void)resetNotifications {
    [NotificationManager clearOldNotifications];
    
    NSMutableArray * notiArr = [UserData sharedUser].notiArr;
    NSMutableArray * weekdays = [UserData sharedUser].weekDays;
    
    for (NSNumber * time in notiArr) {
        int armyTime = [time intValue];
        for (int j = 0; j < [weekdays count] ; j++) {
            NSNumber * wd = [weekdays objectAtIndex:j];
            int wi = [wd intValue];
            if (wi) {
                //Turn 1,2,3,4,5,6,7 to 7,1,2,3,4,5,6
                [NotificationManager registerRegularNotification:armyTime/100 and:armyTime%100 of: (j+1)%7 + 1];
            }
        }
    }
}

- (void)registerRemoteNotification {
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *str = [NSString
                     stringWithFormat:@"%@",deviceToken];
    NSLog(@"%@",str);
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"%@", str);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
}

@end
