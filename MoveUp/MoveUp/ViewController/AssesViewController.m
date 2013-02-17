//
//  AssesViewController.m
//  TestUI
//
//  Created by Ke Ye on 8/6/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "AssesViewController.h"
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "Data.h"
#import "NotificationManager.h"

////////
#import "ASIFormDataRequest.h"
#import "FTAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "FlipView.h"
#import "AnimationDelegate.h"
#import "NoticeViewController.h"
#import "DetailViewController.h"
#import "VTracker.h"
@interface AssesViewController ()

@end

@implementation AssesViewController
@synthesize isPress;
@synthesize partsButtons;
@synthesize partsFlashButtons;
@synthesize tipscontent;
@synthesize tipsview;
@synthesize head;
@synthesize neck;
@synthesize shoulder;
@synthesize back;
@synthesize waist;
@synthesize butt;
@synthesize wrist;
@synthesize leg;
@synthesize bodyBg;
@synthesize pgView;
@synthesize shadow;
@synthesize timeDigit1;
@synthesize timeDigit2;
@synthesize timeDigit3;
@synthesize status;
@synthesize description;
@synthesize goNext;
@synthesize isRate;
@synthesize loading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppBecomeActive" object:nil];
   
    [super dealloc];
    NSLog(@"Assess Dealloc");
}

-(CAAnimation*)fadeInOutAnimation{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.5;
    animation.repeatCount =10000;
    animation.toValue = [NSNumber numberWithFloat:.3];
    animation.autoreverses = YES;
    return animation;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blingEffect) name:@"AppBecomeActive" object:nil];
    
    description=[[DescriptionView alloc]initWithFrame:CGRectMake(0, 0, 140, 70)];
        [self.view insertSubview:description belowSubview:[partsButtons objectAtIndex:0]];
    NSLog(@"the fit rate is %f",[UserData sharedUser].fitRate);
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuBarItem;
    
    [menuBarItem release]; //LEAK
    [menuButton release]; //LEAK
    
    self.navigationItem.title=@"个人主页";
    
    //Set Part Colors
        ///----------------------------------------
    NSLog(@"view will appear");
    
    [[UserData sharedUser] printPersonalInfo];
    
    if ([UIScreen mainScreen].bounds.size.height >= 568.0) {
        pgView =  [[AMProgressView alloc] initWithFrame:CGRectMake(20, 52, 15, 375)
                                      andGradientColors:[NSArray arrayWithObjects:
                                                         [UIColor colorWithRed:0.0f green:0.0f blue:0.3f alpha:0.50f],
                                                         [UIColor colorWithRed:0.3f green:0.3f blue:0.6f alpha:0.75f],
                                                         [UIColor colorWithRed:0.6f green:0.6f blue:0.9f alpha:1.00f], nil]
                                       andOutsideBorder:NO
                                            andVertical:YES];
           crView  = [[CrusierView alloc] initWithFrame:CGRectMake(20, 52, 40, 375)];
        
    }
    else{
        pgView =  [[AMProgressView alloc] initWithFrame:CGRectMake(20, 20, 15, 375)
                                      andGradientColors:[NSArray arrayWithObjects:
                                                         [UIColor colorWithRed:0.0f green:0.0f blue:0.3f alpha:0.50f],
                                                         [UIColor colorWithRed:0.3f green:0.3f blue:0.6f alpha:0.75f],
                                                         [UIColor colorWithRed:0.6f green:0.6f blue:0.9f alpha:1.00f], nil]
                                       andOutsideBorder:NO
                                            andVertical:YES];
           crView  = [[CrusierView alloc] initWithFrame:CGRectMake(20, 20, 40, 375)];
    }

    
    [self.view addSubview:pgView];
    
    [pgView release]; //LEAK
    
    [[UserData sharedUser] updateFitRate];
 
    proCount = 0;
    
    maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4status.png"]];
    maskView.frame = pgView.frame;
    
    [self.view addSubview:maskView];
    
    [maskView release]; //LEAK

    [self.view addSubview:crView];
    
    [crView release]; //LEAK
    
    [self showUpdateReminder];
    
    [self.view bringSubviewToFront:shadow];
    [self.view bringSubviewToFront:tipsview];
    [UserData sharedUser].exDaysNum = [UserData sharedUser].exDaysNum;
    
    int dayDiff = [[UserConfig config] dayDifference:[UserData sharedUser].lastFinishDt to:[NSDate date]];
    
    NSLog(@"Day Diff %d", dayDiff );
    
}

-(IBAction)showDiscription:(id)sender{
    UIButton *click=sender;
    //NSLog(@"%d is the  tag id the x is %f and the y is %f",click.tag);

    [description setPos:click];
}

-(IBAction)hideDiscription:(id)sender{
    [description Disappear];
}


-(void)OKDidPressed {
    
    if (isRate) {
        
        [self performSelector:@selector(flipDelay) withObject:nil afterDelay:0.4];
        int m_appleID= 556483948;
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         m_appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [gorate release];
    }
    else if(isUpdate){
        
        [self performSelector:@selector(flipDelay) withObject:nil afterDelay:0.4];
        int m_appleID= 556483948;
        NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id=%d",m_appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        isUpdate = NO;
    }
}

-(void)otherDidPressed {
    
    if (isRate || isUpdate) { // Tips
        if (isRate || (isUpdate && [UserData sharedUser].exDaysNum != 0)) {
            [self performSelector:@selector(flipDelay) withObject:nil afterDelay:0.4];
        }
        
        [gorate disappear];
        [gorate release];
        isRate = NO;
        isUpdate = NO;
        
    }
    else{ //For Version
        DetailViewController * bodyVC;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] setFloat:[SystemConfig getVersion] forKey:@"version"];
        
        UIApplication *app = [UIApplication sharedApplication];
        [app cancelAllLocalNotifications];
        [app cancelAllLocalNotifications];
        [[UserData sharedUser] resetUser];
        [Data emptytable];
        [ExercisePicker moveDoc];
        [[UserData sharedUser] importUser];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"excerciseFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"InNotification"];
        
        bodyVC = [[DetailViewController alloc] initWithNibName:XIBNameFor(@"DetailViewController") bundle:nil];
        [self.navigationController pushViewController:bodyVC animated:YES];
        
        [bodyVC release];
    }

   
}

-(void)showFlipView:(int) from to:(int)to{
    
    for (UIView * view in self.view.subviews) {
        
        if ([view isKindOfClass:[FlipView class]]) {
            [view removeFromSuperview];
            NSLog(@"Flip View Removed");
        }
    }
    
    AnimationDelegate *animationDelegate;
    AnimationDelegate *animationDelegate2;
    //==========================
    
    animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                          directionType:kDirectionForward];
    animationDelegate.controller = self;
    animationDelegate.perspectiveDepth = 200;
    animationDelegate.nextDuration=0.25;
    animationDelegate.repeatDelay = 0.00;
    animationDelegate.sensitivity = 100;
    animationDelegate.gravity = 2;
    
    
    animationDelegate2 = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                           directionType:kDirectionForward];
    
    animationDelegate2.controller = self;
    animationDelegate2.perspectiveDepth = 200;
    animationDelegate2.nextDuration=0.35;
    animationDelegate2.repeatDelay = 0.00;
    animationDelegate2.sensitivity = 100;
    animationDelegate2.gravity = 2;
    
    FlipView *flipView;
    FlipView *flipView2;
    
    if ([UIScreen mainScreen].bounds.size.height>=568.0) {
        
        flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                     frame:CGRectMake(255, 45, 23, 36)];
        flipView2 = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                      frame:CGRectMake(232,45, 23, 36)];
    }
    else{
        
        flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                     frame:CGRectMake(255, 40, 23, 36)];
        flipView2 = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                      frame:CGRectMake(232,40, 23, 36)];
    }

    
    animationDelegate.transformView = flipView;
    animationDelegate2.transformView = flipView2;
    
    [self.view insertSubview:flipView belowSubview:description];
    [self.view insertSubview:flipView2 belowSubview:description];
    flipView.fontSize = 30;
    flipView2.fontSize = 30;
    
    flipView.font = @"HelveticaNeue-Bold";
    flipView.fontAlignment = @"center";
    flipView.textOffset = CGPointMake(0.0, 0.0);
    flipView.textTruncationMode = kCATruncationEnd;
    
    flipView2.font = @"HelveticaNeue-Bold";
    flipView2.fontAlignment = @"center";
    flipView2.textOffset = CGPointMake(0.0, 0.0);
    flipView2.textTruncationMode = kCATruncationEnd;
    int ten=from/10;
    int single=from-ten*10;
    
    for (int i=0; i<10; i++) {

        [flipView printText:[NSString stringWithFormat:@"%d",(single+9-i)%10] usingImage:nil backgroundColor:[UIColor colorWithRed:0.921f green:0.921f blue:0.921f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];
       
        [flipView2 printText:[NSString stringWithFormat:@"%d",(ten+9-i)%10] usingImage:nil backgroundColor:[UIColor colorWithRed:0.921f green:0.921f blue:0.921f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];
    }
       
    
    //===========================

    int total=to-from;
    int realten=total/10;
    int realsingle=total-10*realten;
    
    if (from != to ) {
        if (realsingle!=0) {
            [animationDelegate startAnimation:kDirectionNone];
            [self performSelector:@selector(stopflip:) withObject:animationDelegate afterDelay:0.25*realsingle];
            
            
        }
        if (realten!=0) {
            [animationDelegate2 startAnimation:kDirectionNone];
            [self performSelector:@selector(stopflip:) withObject:animationDelegate2 afterDelay:0.35*realten];
        }
    }
  
    [flipView release];
    [flipView2 release];
}


-(void)stopflip: (AnimationDelegate *)animation{
    animation.repeat=NO;
}


-(void)showTips{
    if (isRate) {
        [self showRate];
    }
    else{
        [shadow setHidden:NO];
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"];
        NSArray *tips = [[NSArray alloc] initWithContentsOfFile:plistPath];
        tipscontent.text=[tips objectAtIndex:rand()%tips.count];
        [tips release]; //LEAK
        [tipsview popIn:0.8 delegate:nil];
    }

}

-(void)showUpdateReminder {
    
    
    BOOL updatedShowed = [[NSUserDefaults standardUserDefaults] boolForKey:@"UpdatedReminderShowed"];
    if (!updatedShowed) {
        if([SystemConfig needRemindUpdate]) {
            isUpdate = YES;
            goupdate = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
            goupdate.delegate = self;
            [self.view addSubview:goupdate.view];
            [goupdate setType:kMixedType];
            [goupdate setTitle:@"新版发布"];
            [goupdate setContent:@"动动操发布了新的版本！快去下载吧~"];
            [goupdate show];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UpdatedReminderShowed"];
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window addSubview:goupdate.view];
        }
    }
}

-(void)showRate{
    
    isRate = YES;
    gorate = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    gorate.delegate = self;
    [self.view addSubview:gorate.view];
    [gorate setType:kMixedType];
    [gorate setTitle:@"给我评分"];
    [gorate setContent:@"您已经坚持做了两天操啦！请评价一下动动操吧~"];
    [gorate show];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:gorate.view];
}

-(IBAction)closeTips:(id)sender{
    
    [[VTracker tracker] registerLT:@"CLOSETIP"];
    [shadow setHidden:YES];
    [tipsview popOut:0.4 delegate:nil];
    [self performSelector:@selector(flipDelay) withObject:nil afterDelay:0.4];

}
-(void)flipDelay{
        [self showFlipView:[UserData sharedUser].exDaysNum - 1 to:[UserData sharedUser].exDaysNum];
        [UserData sharedUser].startStatus = NORMAL;
}

-(void)displayGoNextBtn {
    

}

-(void)displayProgress {
    
    if ([UserData sharedUser].startStatus== NORMAL) {
        
    if (proCount < (int)[UserData sharedUser].fitRate - 1 ) {
        //NSLog(@"pro count%f", proCount);
        pgView.progress  = proCount/100;
        if (crView.oriPercent != 0) {
            [crView moveTo:pgView.progress withShadowLeft:YES];
            float cd =  [UserData sharedUser].fitRate/100 - [crView oriPercent];
            float ci =  proCount/100 - [crView oriPercent];
            
            [crView setCopyAlpha:1 - (ci/cd)*0.8];
        }
        else{
            [crView moveTo:pgView.progress withShadowLeft:NO];
        }
        proCount += 1 ;
        
    }
    else if(proCount < [UserData sharedUser].fitRate) {
        
        //NSLog(@"pro count%f", proCount);
        pgView.progress  = proCount/100;
        if (crView.oriPercent != 0) {
            [crView moveTo:pgView.progress withShadowLeft:YES];
            float cd =  [UserData sharedUser].fitRate/100 - [crView oriPercent];
            float ci =  proCount/100 - [crView oriPercent];
            
            [crView setCopyAlpha:1 - (ci/cd)*0.8];
        }
        else{
            [crView moveTo:pgView.progress withShadowLeft:NO];
        }
        proCount += 0.1 ;
    }
    else {
        [timer invalidate];
        timer = nil;
        }
    }
}


-(void)showExDays {
    
    int exDays = [UserData sharedUser].exDaysNum;
    
    if(exDays >= 100){
        int figure3 =  exDays/100;
        UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"0金币数字%d",figure3]];
        timeDigit3.image = img;
        
    }
    else
        timeDigit3.alpha = 0;

        int figure1 =  exDays%10;
        UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"0金币数字%d",figure1]];
        timeDigit1.image = img;
        int figure2 =  (exDays%100)/10;
        UIImage * img2 = [UIImage imageNamed:[NSString stringWithFormat:@"0金币数字%d",figure2]];
        timeDigit2.image = img2;
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"---------------DidAppear--------------");
    
    isRate = ([UserData sharedUser].exDaysNum == 2);
    [[VTracker tracker] recountViewTime];
    [super viewDidAppear:animated];
    status = [UserData sharedUser].startStatus;
    if(status == NORMAL) {
        
        [self showFlipView:[UserData sharedUser].exDaysNum to:[UserData sharedUser].exDaysNum];
    }
    else if(status == JUSTADDED) {
        [self.view bringSubviewToFront:shadow];
        [self.view bringSubviewToFront:tipsview];
        [self showTips];
    }
    else {
        [self showFlipView:0 to:[UserData sharedUser].exDaysNum];
        [UserData sharedUser].startStatus = NORMAL;
    }
    status = [UserData sharedUser].startStatus;
    
    if (proCount!=0) {
        [crView setOriPercent:proCount/100];
    }
    
    timer =  [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(displayProgress) userInfo:nil repeats:YES];
    
    float version = [[NSUserDefaults standardUserDefaults] floatForKey:@"version"];
    
    if ([SystemConfig isJustUpdated] && version < 2.0) {
        NoticeViewController * notiViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        notiViewController.delegate = self;
        [self.view addSubview:notiViewController.view];
        [notiViewController setType:kSimpleType];
        [notiViewController setTitle:@"系统升级"];
        [notiViewController setContent:@"新版本升级！能更好地真对您的情况生成动动操，请进一步完善资料！"];
        [notiViewController show];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window addSubview:notiViewController.view];
        
        //[self.view bringSubviewToFront:shadow];
        //[self.view bringSubviewToFront:notiViewController.view];
    }
    else if([SystemConfig isJustUpdated] && version >= 2.0) {
        [ExercisePicker updatePLIST];
    }
}

-(void)fadeinView:(UIImageView *)btn {
    [UIView animateWithDuration:0.6 animations:^{
        btn.alpha = 0.50;
        //waist.alpha = 0.3;
    }completion:^(BOOL isfinished){
       
        [UIView animateWithDuration:1.0 animations:^{
            btn.alpha = 0.1;
            //waist.alpha = 1.0;
        }completion:^(BOOL isfinished){
            [self performSelector:@selector(fadeinView:) withObject:btn afterDelay:18.0];
        }];
    }];
}

-(void)blingEffect{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    for (UIImageView * btn in partsFlashButtons) {
        [btn.layer removeAllAnimations];
    }
    float durantion = 0.4;
    for (UIImageView * btn in partsFlashButtons) {
        btn.alpha = 0.0;
        
        [self performSelector:@selector(fadeinView:) withObject:btn afterDelay:durantion];
        durantion += 1.4;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    
    
    NSLog(@"---------------WillAppear--------------");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    for (UIImageView * btn in partsFlashButtons) {
        [btn.layer removeAllAnimations];
    }
    float durantion = 0.4;
    for (UIImageView * btn in partsFlashButtons) {
        btn.alpha = 0.0;
      
       [self performSelector:@selector(fadeinView:) withObject:btn afterDelay:durantion];
        durantion += 1.4;
    }
    
    NSArray * partArr = @[@"head",@"neck",@"shoulder",@"waist",@"back",@"leg",@"butt",@"wrist"];
    NSArray * partSelectedArr = @[@"head",@"neck",@"shoulder",@"back",@"waist",@"wrist",@"butt",@"leg"];
    int i=0;
    NSLog(@"gender %d",[UserData sharedUser].gender);
    NSString * gender = ([UserData sharedUser].gender)?@"m":@"f";
    
    if ([UserData sharedUser].gender) {
        bodyBg.image = [UIImage imageNamed:@"m_bg2.png"];
        for (UIImageView *partFlash in partsFlashButtons ) {
            NSString *imgName=[NSString stringWithFormat:@"m_%@_Selected.png",[partSelectedArr objectAtIndex:i]];
            [partFlash setImage:[UIImage imageNamed:imgName]];
            i++;
        }
    }
    else {
        bodyBg.image = [UIImage imageNamed:@"f_bg2.png"];
        for (UIImageView *partFlash in partsFlashButtons ) {
            NSString *imgName=[NSString stringWithFormat:@"f_%@_Selected.png",[partSelectedArr objectAtIndex:i]];
            [partFlash setImage:[UIImage imageNamed:imgName]];
            i++;
        }
    }
    
    for (Part * pt in [UserData sharedUser].parts) {
        BodyStat bodystatus = pt.status;
        
        NSString * staStr;
        switch (bodystatus) {
            case BAD:
                staStr = @"BAD";
                break;
            case COMMON:
                staStr = @"COMMON";
                break;
            case GOOD:
                staStr = @"GOOD";
                break;
            case MEDIUM:
                staStr = @"MEDIUM";
                break;
            default:
                break;
        }
        
        int tag = [partArr indexOfObject:pt.name];
        
        NSMutableArray * partViews = [[NSMutableArray alloc]init];
        [partViews addObject:head];
        [partViews addObject:neck];
        [partViews addObject:shoulder];
        [partViews addObject:butt];
        [partViews addObject:wrist];
        [partViews addObject:leg];
        [partViews addObject:back];
        [partViews addObject:waist];
        
        for(UIView * view in partViews){
            UIImageView * imgView;
            if (view.tag == (tag + 10)) {
                imgView = (UIImageView *)view;
                NSString * imgName = [NSString stringWithFormat:@"%@_%@_%@",gender,pt.name,staStr];
                NSLog(@"imgName %@", imgName);
                UIImage * img = [UIImage imageNamed:imgName];
                imgView.image = img;
            }
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated {

    //[[VTracker tracker] registerLT:@"ASSES"];
    
    NSLog(@"View Will Disappear");
    [timer invalidate];
    timer = nil;
    
    proCount = [UserData sharedUser].fitRate;
    pgView.progress = [UserData sharedUser].fitRate /100;
    [crView moveTo:pgView.progress withShadowLeft:NO];
    
    [self.view.layer removeAllAnimations];
}

-(void)showMenu {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(IBAction)goNext:(id)sender{
    [description Disappear];
    self.loading= [[[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 320, 417)] autorelease];
    [self.view addSubview:loading];
    [loading show];
    [self performSelector:@selector(showOut) withObject:nil afterDelay:1];
    
}

- (void)showOut{
    
    NotificationManager * noti = [[NotificationManager alloc] init];
    [noti registerRemoteNotification];
    
#import <QuartzCore/QuartzCore.h>
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:kCATransitionReveal]; //淡入淡出
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    [NotificationManager cancelNotifiction:@"Extra"];
    NSMutableArray * exs = [ExercisePicker choosePart:2];
    
    PlayViewController * playVC;
    playVC = [[PlayViewController alloc]initWithNibName:XIBNameFor(@"PlayViewController") bundle:nil and:exs];
    [self.navigationController pushViewController:playVC animated:NO];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [playVC release];
    [loading hide];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)fadeAnimation:(UIButton *)btn {
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.beginTime = 0.0;
    opacityAnim.duration = 0.3;
    //opacityAnim.removedOnCompletion = YES;
    
    CABasicAnimation *opacityAnim2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim2.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim2.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnim2.beginTime = 0.3;
    opacityAnim2.duration = 1.0;
    
    //动画组
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:opacityAnim,opacityAnim2,nil];
    animGroup.duration = 1.3;
    animGroup.repeatCount = HUGE_VALF;
    
    [btn.layer addAnimation:animGroup forKey:nil];
}


#pragma mark -
#pragma mark AdMoGoDelegate delegate


@end
