//
//  AppDelegate.m
//  TestUI
//
//  Created by Ke Ye on 7/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//
#import "ExercisePicker.h"
#import "AppDelegate.h"
#import "PreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InfoViewController.h"
#import "DetailViewController.h"
#import "UserData.h"
#import "Data.h"
#import "MobClick.h"
#import "actionCount.h"
#import "DetailViewController.h"
#import "NoticeViewController.h"
#import "Reachability.h"
#import "NotificationManager.h"
#define useAppkey @"503ae57d5270151fd700000e"
#define umeng_appkey @"503ae57d5270151fd700000e"
#import "VTracker.h"

#import "UMSocialData.h"
#import "WXApi.h"

#define OverViewTag 10086

//Used for color-changing of IOS Versions Under 5.0
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect {
    UIImage *img = [UIImage imageNamed:@"0navigation@2x.png"];
    [img drawInRect:rect];
}
@end

@implementation AppDelegate 

@synthesize window = _window;
@synthesize preVC = _preVC;
@synthesize AssesVC;
@synthesize NavFirstVC;

- (void)dealloc
{
    [_window release];
    [_preVC release];
    [super dealloc];
}
/**
   didReceiveLocalNotification: Triggered if it is comming through notification 
*/
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [MobClick startWithAppkey:@"503ae57d5270151fd700000e" reportPolicy:REALTIME channelId:nil];
    [MobClick setLogEnabled:YES];
    [MobClick event:@"EnterMode" label:@"Normal_Enter"];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//Will not black-screen when idle
    
    if (application.applicationState == UIApplicationStateInactive ) {
        
        if (AssesVC == nil) {
            NSLog(@"AssesVC is nil, we need to recreate it");
            AssesVC = [[AssesViewController alloc] initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
            
            if(NavFirstVC == nil)
            {
                NSLog(@"Even NavFirstVC is nil, we need to recreate it");
               
                self.preVC = [[[PreViewController alloc] initWithNibName:XIBNameFor(@"PreViewController") bundle:nil] autorelease];
                
                MenuVC = [[MenuViewController alloc]initWithNibName:XIBNameFor(@"MenuViewController") bundle:nil];
                
                self.NavFirstVC = [[[UINavigationController alloc] initWithRootViewController:self.preVC] autorelease];
            }
            [self.NavFirstVC pushViewController:AssesVC animated:YES];
            [AssesVC release];//LEAK
        }
        
        
        if([AssesVC.navigationController visibleViewController] != AssesVC) {
            [self restoreViewLocation];
            [AssesVC.navigationController popToViewController:AssesVC animated:YES];
        }
        else {
            [self restoreViewLocation];
        }
        
        //Identify the currentTime.//Modify
        NSDate * nowdt = [NSDate date];
        int unit =NSMonthCalendarUnit |NSYearCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:unit fromDate:nowdt];
        float timeIdentifier = [componets month] * 1000000 + [componets day] * 10000 + [componets hour] * 100 + [componets minute];
        
    
            
            [[VTracker tracker] registerGR:@"COME_BY_NOTI"];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"NotiMHTime"] != timeIdentifier ){
                UIActionSheet *option=[[[UIActionSheet alloc]initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"有点忙，这次先不做了"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles:@"去做操", @"推迟15分钟",
                                       nil] autorelease];
                
                [option showInView: AssesVC.view];
            }
            else {
                
                [[NSUserDefaults standardUserDefaults] setFloat:0.0 forKey:@"NotiMHTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIActionSheet *option=[[[UIActionSheet alloc]initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"有点忙，这次先不做了"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles:@"去做操",
                                       nil] autorelease];
                
                [option showInView: AssesVC.view]; 
            }
        }
        
    if(application.applicationState == UIApplicationStateActive ) { 
        //The application received a notification in the active state, so you can display an alert view or do something appropriate.
    }
    
    NSString * str = [notification.userInfo objectForKey:@"Type"];
    NSLog(@"Type : %@",str);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    
    
    NSString *str = [NSString
                     stringWithFormat:@"%@",deviceToken];
    NSLog(@"%@",str);
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", str);
    
    [UserData sharedUser].token = str;
    
    if ([UserData sharedUser].token){
        [[VTracker tracker] packageUerInfo];
        [[VTracker tracker] sendOutData];
    }
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UMSocialData setAppKey:umeng_appkey];
    [WXApi registerApp:@"wx940f1edaf36ae332"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UpdatedReminderShowed"];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"needUpdate"]) {
        if ([self isNetWork]) {
            [[VTracker tracker] checkVersion];
        }
    }
    
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    
    //Start UMeng
    [MobClick startWithAppkey:@"503ae57d5270151fd700000e" reportPolicy:REALTIME channelId:nil];
    [MobClick setLogEnabled:YES];
    [MobClick event:@"EnterMode" label:@"Normal_Enter"];
    
    //Main UI Settings
    
    mainVC =  [[UIViewController alloc]init];
    mainVC.view = [[[UIView alloc]init] autorelease];
    mainVC.view.frame = [UIScreen mainScreen].bounds;
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"introFinished"]){//Need To finish the introduction here
        
        [[NSUserDefaults standardUserDefaults] setFloat:[SystemConfig getVersion] forKey:@"version"];
        [ExercisePicker moveDoc];
        
        self.preVC = [[[PreViewController alloc] initWithNibName: XIBNameFor(@"PreViewController") bundle:nil] autorelease];
        MenuVC = [[MenuViewController alloc]initWithNibName:XIBNameFor(@"MenuViewController") bundle:nil];
        self.NavFirstVC = [[[UINavigationController alloc] initWithRootViewController:self.preVC] autorelease];
        NavState = InStage;
        
        UIImage *image  = [UIImage imageNamed:@"0navigation.png"];
        if([[UINavigationBar class] respondsToSelector:@selector(appearance)])
        {
            [[self.preVC.navigationController navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
        [self.preVC.navigationController setNavigationBarHidden:YES animated:NO];
        
        //[self.window addSubview:MenuVC.view];
        self.window.rootViewController = mainVC;
        [self.window.rootViewController.view addSubview:MenuVC.view];
        [self.window.rootViewController.view addSubview:NavFirstVC.view];
        
        //NavFirstVC.view.frame = CGRectMake(0, 0, 640, 480);
        [self.window makeKeyAndVisible];
    }
    else if(![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
        
        
        [[UserData sharedUser] exportUser];
        
    
        DetailViewController * bodyVC;
        
        bodyVC = [[DetailViewController alloc] initWithNibName:XIBNameFor(@"DetailViewController") bundle:nil];
        MenuVC = [[MenuViewController alloc]initWithNibName:XIBNameFor(@"MenuViewController") bundle:nil];
        self.NavFirstVC = [[[UINavigationController alloc] initWithRootViewController:bodyVC] autorelease];
        NavState = InStage;
        
        [bodyVC release];
        
        UIImage *image  = [UIImage imageNamed:@"0navigation.png"];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        [[bodyVC.navigationController navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault]; 
        
        [self.preVC.navigationController setNavigationBarHidden:YES animated:NO];
        
        //[self.window addSubview:MenuVC.view];
        
        self.window.rootViewController = mainVC;
        [self.window.rootViewController.view addSubview:MenuVC.view];
        [self.window.rootViewController.view addSubview:NavFirstVC.view];
        
        //NavFirstVC.view.frame = CGRectMake(0, 0, 640, 480);
        [self.window makeKeyAndVisible];
    }
    else {
        
        [[UserData sharedUser] exportUser];
        
        
        [[VTracker tracker] registerGR:@"COME_BY_NORMAL"];
        
        UserData * ud = [UserData sharedUser];
        
        NSLog(@"Last Date %@", [ud.lastdt description]);
        
        AssesVC = [[AssesViewController alloc]
                   initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
        
        MenuVC = [[MenuViewController alloc]initWithNibName:XIBNameFor(@"MenuViewController") bundle:nil];

        self.NavFirstVC = [[[UINavigationController alloc] initWithRootViewController:AssesVC] autorelease];
        
        [AssesVC release]; //LEAK
        
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(cancel)forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
        
        [menuButton release];
        
        AssesVC.navigationItem.title=@"个人主页";
        NavState = InStage;
        
        UIImage *image  = [UIImage imageNamed:@"0navigation.png"];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        [[AssesVC.navigationController navigationBar] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        AssesVC.navigationItem.leftBarButtonItem = menuBarItem;
        [menuBarItem release];
        
        //[self.window addSubview:MenuVC.view];
        self.window.rootViewController = mainVC;
        [self.window.rootViewController.view addSubview:MenuVC.view];
        [self.window.rootViewController.view addSubview:NavFirstVC.view];
        //NavFirstVC.view.frame = CGRectMake(0, 0, 640, 480);
        [self.window makeKeyAndVisible];
        
        [mainVC release];
    }
    return YES;
}


#pragma AnimationMethods

-(void)cancel {
    [self animateHomeViewToSide:CGRectMake(290.0f, 
                                            NavFirstVC.view.frame.origin.y,
                                            NavFirstVC.view.frame.size.width,
                                            NavFirstVC.view.frame.size.height)];
    [self makeLeftViewVisible];
}

-(void)invisible {
    [self animateHomeViewToSide:CGRectMake(360.0f,
                                           NavFirstVC.view.frame.origin.y,
                                           NavFirstVC.view.frame.size.width,
                                           NavFirstVC.view.frame.size.height)];
    [self makeLeftViewVisible];
}

-(void)switchView:(UIViewController *)viewController {
    
    [self animateSideAndBack:CGRectMake(320.0f, 
                                        NavFirstVC.view.frame.origin.y, 
                                        NavFirstVC.view.frame.size.width, 
                                        NavFirstVC.view.frame.size.height) withController:viewController];
}

- (void)animateSideAndBack:(CGRect)newViewRect withController: (UIViewController *)viewController {
    [UIView animateWithDuration:0.05 
                     animations:^{
                         NavFirstVC.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         if (viewController!=nil) {
                             [NavFirstVC pushViewController:viewController animated:NO];
                             //[viewController release];
                         }
                         
                        [self performSelector:@selector(restoreViewLocation) withObject:nil afterDelay:0.1];
                     }];
}


// animate home view to side rect
- (void)animateHomeViewToSide:(CGRect)newViewRect {
    
    [UIView animateWithDuration:0.2 
                     animations:^{
                         NavFirstVC.view.frame = newViewRect;
                     } 
                     completion:^(BOOL finished){
                         //Add an overView to enable tag on the whole area NavFristVC shows.
                         
                         UIControl *overView = [[UIControl alloc] init];
                         overView.tag = OverViewTag;
                         overView.backgroundColor = [UIColor clearColor];
                         overView.frame = NavFirstVC.view.frame;
                         [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
                         [[[UIApplication sharedApplication] keyWindow] addSubview:overView];
                         [overView release];
                     }];
}


- (void)restoreViewLocation {
    [UIView animateWithDuration:0.2 
                     animations:^{
                        NavFirstVC.view.frame = CGRectMake(0, 
                        NavFirstVC.view.frame.origin.y, 
                        NavFirstVC.view.frame.size.width, 
                        NavFirstVC.view.frame.size.height);
                         
                     } 
                     completion:^(BOOL finished){
                         UIControl *overView = (UIControl *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:OverViewTag];
                         [overView removeFromSuperview];
                     }];
}


- (void)makeLeftViewVisible {
    NavFirstVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
    NavFirstVC.view.layer.shadowOpacity = 0.4f;
    NavFirstVC.view.layer.shadowOffset = CGSizeMake(-5.0, 1.0f);
    NavFirstVC.view.layer.shadowRadius = 4.0f;
    NavFirstVC.view.layer.masksToBounds = NO;
    NavFirstVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:NavFirstVC.view.bounds].CGPath;
}


#pragma Application Delegate Callbacks
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[VTracker tracker] registerGR:@"PUTTOBG"];
    [[VTracker tracker] packageBehaviors];
    [[VTracker tracker] sendOutData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppBecomeInActive" object:nil];
    [[UserData sharedUser] importUser];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[VTracker tracker] registerGR:@"GOBACKTOFG"];
    [[VTracker tracker] packageBehaviors];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma Delegate ActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {  
      
        if (buttonIndex == actionSheet.cancelButtonIndex) {
            [[NSUserDefaults standardUserDefaults] setFloat: 0.0f forKey:@"notiHMTime"]; //Cancel It
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[VTracker tracker] registerGR:@"NOTI_FAIL"];
            [[VTracker tracker] sendOutData];
        }
        else if(buttonIndex == 0) { //OK go exercising 
            
            [AssesVC goNext:nil];
            [[VTracker tracker] registerGR:@"NOTI_SUCCESS"];
            [[VTracker tracker] sendOutData];
        }
        else {
            
            [[VTracker tracker] registerGR:@"NOTI_DELAY"];
            [[VTracker tracker] sendOutData];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"InNotification"];
            [[NSUserDefaults standardUserDefaults] synchronize];
    
            
            [NotificationManager registerOneTimeNotification:0 and:15 after:[NSDate date]];
        }

}

/**
  makeNotification: Make notification accroding to the hours and minutes after call.
  hh: hours
  mm: minutes
 */


- (BOOL)isNetWork
{
    BOOL reachability;
    Reachability *reach = [Reachability reachabilityWithHostName:@"202.108.22.5"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            //无网络连接
            reachability = NO;
            return reachability;
            break;
        case ReachableViaWWAN:
            //使用3g网络
            reachability = YES;
            return reachability;
            break;
        case ReachableViaWiFi:
            //使用wifi
            reachability = YES;
            return reachability;
            break;
            
        default:
            break;
    }
    
    return reachability;
}

-(void)showSharingSheet{

    UIActionSheet *option=[[[UIActionSheet alloc]initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle: nil
                                            otherButtonTitles:@"新浪微博",@"人人网",@"腾讯微博", @"官方微博", @"请您评分",
                           nil] autorelease];
    option.tag = 1000;
    [option showInView:mainVC.view];
    
}
-(void)ShowRating {
    BOOL reachability = [self isNetWork];
    if (reachability) {
        NSLog(@"111111");
        int m_appleID= 565843279;
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         m_appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)ShowWeibo {
    BOOL reachability = [self isNetWork];
    if (reachability) {
        NSString *str = [NSString stringWithFormat:
                         @"http://www.weibo.com/freexuestudio"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}





@end
