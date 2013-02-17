//
//  AppDelegate.h
//  TestUI
//
//  Created by Ke Ye on 7/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "PreViewController.h"
#import "AssesViewController.h"
#import "WXApi.h"
#import "UMSocialControllerService.h"


@class ViewController;

enum {
    OutOfStage,
    InStage
} NavState; //Show right now or not

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate> {
    MenuViewController * MenuVC;
    AssesViewController * AssesVC; 
    UINavigationController *NavFirstVC;
    UIViewController * mainVC;
    float notiHMTime; //identify which notification it is, use time like 1600, means 16:00
}

@property (strong, nonatomic) UIWindow * window; 
@property (strong, nonatomic) AssesViewController * AssesVC;
@property (strong, nonatomic) PreViewController * preVC;
@property (strong, nonatomic) UINavigationController *NavFirstVC;



-(void)switchView:(UIViewController *)viewController;
-(void)cancel;
-(void)invisible;
-(void)showSharingSheet;
//-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
@end
