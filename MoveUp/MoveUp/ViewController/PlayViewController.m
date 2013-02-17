//
//  PlayViewController.m
//  TestUI
//
//  Created by Ke Ye on 8/1/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "PlayViewController.h"
#import "AssesViewController.h"
#import "InfoViewController.h"
#import "UserData.h"
#import "Data.h"
#import "AchieveViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "UMSocialMacroDefine.h"
#import "UIView+Genie.h"
#import "VTracker.h"
#define endRect(r) CGRectMake(r.origin.x+15, r.origin.y+15, 0, 0)
#define fullRect CGRectMake(0,38,320,406)

@interface PlayViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@end

@implementation PlayViewController

@synthesize musicSlider;
@synthesize controlBtn;
@synthesize controlView;
@synthesize triggerView;
@synthesize mView;
@synthesize viewSwitchBtn;
@synthesize tips;
@synthesize pileView;
@synthesize numofmove;
@synthesize draggedView;
@synthesize viewIsIn;
@synthesize loading;
@synthesize MVPlayer;
@synthesize illuView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil and:(NSMutableArray *)exs
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        data = [[Data alloc]init];
        choosenExs = exs;
        [choosenExs retain];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        textLabel.numberOfLines = 4;
        textLabel.text = @"test";
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,90 , 150, 120)];
        NSString *imageName = [NSString stringWithFormat:@"yinxing%d.jpg",rand()%4];
        _imageView.image = [UIImage imageNamed:imageName];
        // [self.view addSubview:_imageView];
        
        UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:@"UMSocialSDK" withTitle:nil];
        
        socialData.shareText = textLabel.text;
        socialData.shareImage = _imageView.image;
        
        SAFE_ARC_RELEASE(textLabel);
        
        _socialController = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
        _socialController.soicalUIDelegate = self;
        SAFE_ARC_RELEASE(socialData);
    }
    return self;
}


-(void)closePlayer {
    
    if (finished == NO) {
        if(!illuView.isBusy && illuView.status == kAtDownSide){
            
            if (illuView.hintPlayer.isPlaying) {
                [illuView.hintPlayer pause];
                illuView.disrupted = YES;
            }
        }
        else {
             [self play_stop];
        }
    }
}

-(void)continuPlayer {
    
    if (finished == NO) {
        if(!illuView.isBusy && illuView.status == kAtDownSide){
            
            if (illuView.disrupted == YES) {
                [illuView.hintPlayer play];
                illuView.disrupted = NO;
            }
            
        }
        else {
            [self play_stop];
        }
    }
}

-(void)dealloc {
    
    NSLog(@"PlayViewController! Dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:MVPlayer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:MVPlayer];

    [[NSNotificationCenter defaultCenter] removeObserver:self name: MPMoviePlayerPlaybackDidFinishNotification object:MVPlayer];
    
    if (hintPlayer) {
        [hintPlayer release];
    }
    
    [mView release];
    [MVPlayer release];
    
    [controlBtn release];
    [durationLbl release];
    [durationLbl1 release];
    //[tips release];
    
    //[fileArray release];
    [controlView release];
    [triggerView release];
    [backButton release];
    [illuView release];
    
    //[readSwitchBtn release];
    [viewSwitchBtn release];
    
    [super dealloc];
    NSLog(@"playView DEALLOC FINISH");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    indicationBtn.hidden = YES;
    finished = YES;
    triggerView.alpha = 0;
    [[UserData sharedUser] printPersonalInfo];
    //exerciseOrders = [ExercisePicker setParts];
    
    viewSwitchBtn.tag = 1;
    
    indicationHasAutoShowed = NO;
    indicationHasAutoHided = NO;
    
    [tips setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlayer) name:@"AppBecomeInActive" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuPlayer) name:@"AppBecomeActive" object:nil];
    
    index = 0;
    duration = 0;
    focused = YES;
    needToChangeView = NO;
    hiddenstatus=YES;
    
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"0back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBarItem =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    [backBarItem release];
    //--------------------exerciseOrders
    
    //choosenExs = [ExercisePicker choosePart:2];
    //Change: Here to Initialize MVPlayerView, with Miexed View;
    Exercise * ex = [choosenExs objectAtIndex:index];
    
    draggedView.hidden = YES;
    draggedView.alpha = 0.0;
    shadowView.hidden = YES;
    shadowView.alpha = 0.0;
    
    numofmove.text=[NSString stringWithFormat:@"%d/%d",index+1,choosenExs.count];
    self.navigationItem.title= ex.title;
    
    //-------------------NEW CODE--------------------------------
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:ex.videoPath ofType:@"m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    MPMoviePlayerController * mvplayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.MVPlayer = mvplayer;
    [mvplayer release];
    
    NSLog(@"=============CONTROL MVPlayer=========%d", MVPlayer.retainCount);
    
    MVPlayer.controlStyle=MPMovieControlStyleDefault;
    [MVPlayer prepareToPlay];
    [MVPlayer.view setFrame:CGRectMake(0, 0, 320, 360)];  // player的尺寸
    [MVPlayer setControlStyle:MPMovieControlStyleNone];
    
    //------------------------------------------------------------
    
    mView.tView.touchDelegate = self;
    mView.touchView.touchDelegate = self;
    
    //[mView configWords:ex.content];
    
    illuView.delegate = self;
    [illuView setContent:ex];
        
    [mView configVideo:MVPlayer.view];
    //Random Music
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateChanged:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:MVPlayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerPlaybackStateChanged:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:MVPlayer];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(moviePlayBackDidFinish:)
     name:MPMoviePlayerPlaybackDidFinishNotification
     object: MVPlayer
     ];
    
    
    NSLog(@"=============CONTROL MVPlayer=========%d", MVPlayer.retainCount);
    
    //--------------------------------------------------

    [self showFigures];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [triggerView InitOrder:fileArray];
    
    
    
    if ([SystemConfig isIphone5]) {
        sdView = [[ShadowView alloc] initWithImage:[UIImage imageNamed: @"shadow-568h.png"]];

    }
    else
    sdView = [[ShadowView alloc] initWithImage:[UIImage imageNamed:@"shadow-568h.png" ]];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window addSubview:sdView];
    sdView.alpha = 0;
    
    finished = NO;
    
    loading= [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 320, 417)];
    [self.view insertSubview:loading belowSubview:triggerView];
}

#pragma mark illuViewDelegate 

-(void)continuePlay {
    if (MVPlayer.playbackState == MPMoviePlaybackStatePaused && !finished) {
         [self play_stop];
        controlView.userInteractionEnabled = YES;
        controlBtn.enabled = YES;
        musicSlider.enabled = YES;
    }
}

-(void)stopPlay {
    
    if(MVPlayer.playbackState == MPMoviePlaybackStatePlaying){
        [self play_stop];
        controlView.userInteractionEnabled = NO;
        controlBtn.enabled = NO;
        musicSlider.enabled = NO;
    }
}

-(void)decreaseVolume {
    
}

-(void)initAcuView:(Exercise *)ex {
    
    if (!indicationHasAutoShowed ) {
        
        viewIsIn = NO;
        draggedView.acImg = [UIImage imageNamed:ex.i_ImagePath];
        draggedView.description = ex.i_Description;
        indicationHasAutoShowed = YES;
        [draggedView setNeedsDisplay];
        [MVPlayer pause];
        [UIView animateWithDuration:0.6 animations:^{
            
            draggedView.hidden = NO;
            shadowView.hidden = NO;
            shadowView.alpha = 1.0;
            draggedView.alpha = 1.0;
            indicationBtn.enabled = NO;
            controlBtn.enabled = NO;
            musicSlider.enabled = NO;
            
        }completion:^(BOOL isfinished){
            
            if (!backTapped) {
                
                indicationBtn.enabled = YES;
                musicSlider.enabled = YES;
                
                NSString * soundFilePath = [[NSBundle mainBundle] pathForResource:ex.i_SoundPath ofType:@"mp3"]; //The Output
                NSURL * soundURL= [[NSURL alloc] initFileURLWithPath:soundFilePath];
                NSError * error = nil;
                
                hintPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:&error];
                hintPlayer.volume = 3;
                [hintPlayer setNumberOfLoops:0];
                hintPlayer.delegate = self;
                [hintPlayer play];
                
                [soundURL release];
            }
        }];
        [UIView commitAnimations];
    }
    else {
        
        [UIView animateWithDuration:0.6 animations:^{
        
            shadowView.hidden = NO;
            shadowView.alpha = 1.0;
            indicationBtn.enabled = NO;
            controlBtn.enabled = NO;
            
        }completion:^(BOOL isfinished){
            
        }];
        [UIView commitAnimations];
        
        [MVPlayer pause];
        [self genieToRect:indicationBtn.frame edge:BCRectEdgeBottom];
    }
}

-(void)hideAcuView {
    
    [hintPlayer stop];
    self.viewIsIn = false;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        shadowView.hidden = YES;
        shadowView.alpha = 0.0;
        
    }completion:^(BOOL isfinished){
        
    }];
    [UIView commitAnimations];
    
    [self genieToRect:indicationBtn.frame edge:BCRectEdgeBottom];
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notification
{
    NSLog(@"LoadState Did Change %d", MVPlayer.loadState);
    
    if((MVPlayer.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
    {
        NSLog(@"============Loading Succeed!!!==============");
        //if load state is ready to play
        
        if (index == 0) {
            [loading setHidden:YES];
        }
        else {
            [loading hide];
        }
        //---+-+-+-+-+->
        
        Exercise * exercise = [choosenExs objectAtIndex:index];
        
        if (exercise.hasIndication) {
            
            double  time = exercise.startSec - MVPlayer.currentPlaybackTime - 0.8;
            if (!illuView.isPulledByUser) {
        
                illuView.firstIndicationShowing = YES;
                [illuView performSelector:@selector(goDown)withObject:nil afterDelay:time];
            }
        
        }else {

            illuView.receiveTouchEnabled = YES;
        }
        
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button.png"] forState:UIControlStateNormal];
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button_down.png"] forState:UIControlStateHighlighted];
        
        [self performSelector:@selector(hideView:) withObject:controlView afterDelay:2.5];
        [self performSelector:@selector(showView:) withObject:triggerView afterDelay:2.5];
        
        [musicSlider addTarget:self action:@selector(progressSliderMoved) forControlEvents:UIControlEventTouchUpInside];
        [musicSlider addTarget:self action:@selector(progressSliderTouched) forControlEvents:UIControlEventTouchDown];
        
        musicSlider.maximumValue = (float)MVPlayer.duration;
        musicSlider.minimumValue = 0.0;
        
        NSLog(@"============PLAY_STOP!!!==============");
    }
}


-(void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    if (index < 1 && !backTapped) {
        
        [loading setSecondImage];
        indicationBtn.hidden = YES;
        [loading show];
        index ++;
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button.png"] forState:UIControlStateNormal];
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button_down.png"] forState:UIControlStateHighlighted];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self nextReading];
    }
    else if(!backTapped){
        
        [[UserData sharedUser] addProgress];
        [self finish];
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button.png"] forState:UIControlStateNormal];
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button_down.png"] forState:UIControlStateHighlighted];
        
    }else if(backTapped) {
    
    }
}

//New
-(void)moviePlayerPlaybackStateChanged:(NSNotification *)notification
{
    
}

-(void)showTriggerView {
    [self triggered:nil];
}

-(void)finish {
    
    self.viewSwitchBtn.enabled = NO;
    
    [illuView stopPlayer];
   
    [sdView fadeIn];
    
    finished = YES;
    
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    
    fsVC = [[FinishViewController alloc] initWithNibName:XIBNameFor(@"FinishView") bundle:nil];
    
    sp = [[StarPanel alloc] initWithFrame:CGRectMake(-160, 0, 640, 300)];
    sp.backgroundColor = [UIColor clearColor];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate.window addSubview:sp];
    
    fsVC.view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - fsVC.view.frame.size.width)/2.0, ([UIScreen mainScreen].bounds.size.height - fsVC.view.frame.size.height)/2.0 , fsVC.view.frame.size.width, fsVC.view.frame.size.height);
    [appDelegate.window addSubview:fsVC.view];
    fsVC.view.alpha = 0;
    fsVC.delegate = self;
    
    [[UserData sharedUser] updateExDaysNum];
    [[UserData sharedUser] updateFitRate];
    [ExercisePicker updateExandParts:choosenExs];
    
    Exercise * ex = [choosenExs objectAtIndex:index];
    [[VTracker tracker] registerEX:@"FINISH" with:ex.exName happensin:1000];
    [[VTracker tracker] packageBehaviors];
    [[VTracker tracker] packageDailyInfo];
    [[VTracker tracker] sendOutData];
    
    int acIndex = [[UserData sharedUser] isWinningAchievement];
    if (acIndex != -1) {
        
        acVC = [[AchieveViewController alloc]initWithNibName:XIBNameFor(@"AchieveView") bundle:nil];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MedalList" ofType:@"plist"];
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        NSArray * arr = [dictionary objectForKey:@"Medal"];
        NSDictionary * item = [arr objectAtIndex:acIndex];
        NSString * name = [item objectForKey:@"Title"];
        NSString * content =[item objectForKey:@"Content"];
        NSString * img = [item objectForKey:@"Image"];
        NSLog(@"Name %@ Content %@ Img %@", name, content, img);
        
        [dictionary release];
        
        [acVC InitInfo:name and:content and:img];
        
        [appDelegate.window addSubview:acVC.view];
        acVC.view.alpha = 0;
        
        acVC.view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - acVC.view.frame.size.width)/2.0, ([UIScreen mainScreen].bounds.size.height)/2.0 + 10, acVC.view.frame.size.width, acVC.view.frame.size.height);
        [fsVC showUp:acVC];
    }
    else {
        [fsVC showUp];
    }
    
    musicSlider.enabled = NO;
    controlBtn.enabled = NO;
    
    [triggerView GoNextPanel];
    [self showView:triggerView];
    [self hideView:controlView];
    
    [timer invalidate];
    timer = nil;
    
    [controlBtn setImage:[UIImage imageNamed:@"7play_button.png"] forState:UIControlStateNormal];
    [controlBtn setImage:[UIImage imageNamed:@"7play_button_down.png"] forState:UIControlStateHighlighted];
    
    [[UserData sharedUser] importUser];
}

-(void)finishExcercise {
    
    [sdView removeFromSuperview];
    [acVC.view removeFromSuperview];
    [fsVC.view removeFromSuperview];
    [sp removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)goshare{

    UIActionSheet *option=[[[UIActionSheet alloc]initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle: nil
                                            otherButtonTitles:@"新浪微博",@"微信朋友圈",@"微信对话",
                           nil] autorelease];
    option.tag = 1000;
    [option showInView:self.view];
    
}



-(void)progressSliderDraged {
    
    NSLog(@"Touched and touch");
}

-(void)progressSliderTouched {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    hiddenstatus=NO;
    [MVPlayer pause];
}

-(void)progressSliderMoved {
    
    Exercise * ex = [choosenExs objectAtIndex:index];
    
    [[VTracker tracker] registerEX: @"SLIDERDRAGED" with: ex.exName  happensin:MVPlayer.currentPlaybackTime];
    
    illuView.isPulledByUser = YES;
    hiddenstatus=YES;
    
    if (!backTapped) {
        [self cancelShowSelectors];
        
        [self performSelector:@selector(hideView:) withObject:controlView afterDelay:2.5];
        [self performSelector:@selector(showView:) withObject:triggerView afterDelay:2.5];
    }
    
    [controlBtn setImage:[UIImage imageNamed:@"7pause_button.png"] forState:UIControlStateNormal];
    [controlBtn setImage:[UIImage imageNamed:@"7pause_button_down.png"] forState:UIControlStateHighlighted];

    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    MVPlayer.currentPlaybackTime = musicSlider.value;
    [MVPlayer play];
}

-(void)updateTime {
    
    [self showFigures];
    
    musicSlider.value = MVPlayer.currentPlaybackTime;
    NSLog(@"%f ", MVPlayer.currentPlaybackTime);
}

-(void)showFigures {
    
    if (MVPlayer.duration - MVPlayer.currentPlaybackTime <= 2.0 && illuView.receiveTouchEnabled == YES) {
        
        if (illuView.status == kAtDownSide || (illuView.status == kAtUpSide && illuView.isBusy )) {
            [illuView goUp];
        }
        illuView.receiveTouchEnabled = NO;
    }
    
    int minute = ((int)(MVPlayer.duration - MVPlayer.currentPlaybackTime))/60;
    int second = ((int)(MVPlayer.duration - MVPlayer.currentPlaybackTime))%60;
    
    NSString * strmin;
    NSString * strsec;
    
    if (minute < 10) {
        strmin = [NSString stringWithFormat:@"%d",minute];
    }
    else {
        strmin = [NSString stringWithFormat:@"%d",minute];
    }
    
    if (second < 10) {
        strsec = [NSString stringWithFormat:@"0%d",second];
    }
    else {
        strsec = [NSString stringWithFormat:@"%d",second];
    }
    durationLbl.text = [NSString stringWithFormat:@"%@:%@",strmin,strsec];
    durationLbl1.text = [NSString stringWithFormat:@"%@:%@",strmin,strsec];
    
    pileView.percent =  MVPlayer.currentPlaybackTime / MVPlayer.duration;
    [pileView setNeedsDisplay];
}


-(void)cancelShowSelectors {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView:) object:controlView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showView:) object:controlView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView:) object:triggerView];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showView:) object:triggerView];
}

static bool isTriggering = NO;
-(IBAction)triggered:(id)sender {
    
    [self cancelShowSelectors];
    if (MVPlayer.playbackState == MPMoviePlaybackStatePlaying || (hintPlayer.isPlaying)) {
        
        if(!isTriggering) {
            isTriggering = YES;
            
            [self showView: controlView];
            [self hideView: triggerView];
        }
        
        if (!backTapped) {
            if (MVPlayer.playbackState == MPMoviePlaybackStatePlaying){
                [self performSelector:@selector(hideView:) withObject:controlView afterDelay:2.5];
                [self performSelector:@selector(showView:) withObject:triggerView afterDelay:2.5];
            }
                            
        }
    }
    else {
    
    [self showView: controlView];
    [self hideView: triggerView];
    }
}

-(void)hideView:(UIView *)view {
    
    if (hiddenstatus==YES) {
        view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             view.alpha = 0;
                             tips.alpha = 0;
                            
                         }
                         completion:^(BOOL finished){
                             isTriggering = NO;
                             view.userInteractionEnabled = YES;
                         }];
        [UIView commitAnimations];
    }
}

-(void)showView:(UIView *)view {
    
    if (view == triggerView) {
        [illuView popbackALittle];
    }
    else if(view == controlView) {
        [illuView popoutALittle];
    }
    
    if (hiddenstatus==YES) {
        view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             view.alpha = 1;
                             //shadowView.frame = CGRectMake(-10, 0, 10, 480);
                         }
                         completion:^(BOOL finished){
                             view.userInteractionEnabled = YES;
                         }];
        [UIView commitAnimations];
    }
}

-(IBAction)play_stop {
    
    [self cancelShowSelectors];

    NSLog(@" MVPlayer.playbackState %d", MVPlayer.playbackState);
     Exercise * ex = [choosenExs objectAtIndex:index];
    if (MVPlayer.playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"============PLAY_STOP PLAY==============");
        
        if(MVPlayer.currentPlaybackTime <= ex.startSec) {
            isIndicationStored = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self];
        }
        
        [MVPlayer pause];
        
        controlView.alpha = 1;
        triggerView.alpha = 0;
        [controlBtn setImage:[UIImage imageNamed:@"7play_button.png"] forState:UIControlStateNormal];
        [controlBtn setImage:[UIImage imageNamed:@"7play_button_down.png"] forState:UIControlStateHighlighted];
        
        [self showView:controlView];
        [self hideView:triggerView];
    }
    else if(MVPlayer.playbackState == MPMoviePlaybackStatePaused ||  MVPlayer.playbackState == MPMoviePlaybackStateStopped){
        
        NSLog(@"============PLAY_STOP STOP==============");
        
        [MVPlayer play];
        
        if (isIndicationStored) {
            
            double  time = ex.startSec - MVPlayer.currentPlaybackTime;
            //[self performSelector:@selector(initAcuView:) withObject:[choosenExs objectAtIndex:index] afterDelay:time];
            //version 2.1
            isIndicationStored = NO;
        }
        
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button.png"] forState:UIControlStateNormal];
        [controlBtn setImage:[UIImage imageNamed:@"7pause_button_down.png"] forState:UIControlStateHighlighted];
        
        if (!backTapped) {
            [self performSelector:@selector(hideView:) withObject:controlView afterDelay:2.5];
            [self performSelector:@selector(showView:) withObject:triggerView afterDelay:2.5];
        }
    }
}

-(void)goNextAnimation {
    
    NSLog(@"goNextAnimation");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if (focused) {
        
        indicationBtn.enabled = YES;
        indicationBtn.hidden = YES;
        finished = NO;
        musicSlider.enabled = YES;
        controlBtn.enabled = YES;
        
        [self hideView:controlView];
        [self showView:triggerView];
        
        needToChangeView = NO;
        Exercise * ex = [choosenExs objectAtIndex:index];

        self.navigationItem.title= ex.title;
        //[mView configWords:ex.content];
        
        [illuView setContent:ex];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *moviePath = [bundle pathForResource:ex.videoPath ofType:@"m4v"];
        NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
        
        MVPlayer.contentURL = movieURL;
        MVPlayer.controlStyle = MPMovieControlStyleNone;
        [MVPlayer prepareToPlay];
        
        
        
    }
}

-(void)nextReading {
    
    NSLog(@"Come In To Next Reading");
    //numofmove.text
    [triggerView GoNextPanel];
        numofmove.text=[NSString stringWithFormat:@"%d/%d",index+1,choosenExs.count];
    
    [self showView:controlView];
    [self hideView:triggerView];
    
    musicSlider.enabled = NO;
    controlBtn.enabled = NO;
    indicationBtn.enabled = NO;
    
    finished = YES;
    
    [illuView stopPlayer];
    [self performSelector:@selector(goNextAnimation) withObject:nil afterDelay:2.5];
}

-(void)stop {
   
}

-(void)back {
    
    [self.view.layer removeAllAnimations];
    
    [illuView stopPlayer];
    illuView.delegate = nil;
    
    backTapped = YES;
    Exercise * ex = [choosenExs objectAtIndex:index];
    [[VTracker tracker] registerEX:@"GiveUp" with:ex.exName happensin:MVPlayer.currentPlaybackTime];
    [[VTracker tracker] packageDailyInfo];
    
    [timer invalidate];
    timer = nil;
    [MVPlayer stop];
    
    [hintPlayer stop];
    hintPlayer.delegate = nil;
    
    focused = NO;
    
    mView.touchView.touchDelegate = nil;
    mView.tView.touchDelegate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
   
    [MobClick event:@"GiveUpExcercise"];
    

}


-(void)filterBG:(float)alpha {
    if (alpha!=0 && shadowView.hidden) {
        shadowView.hidden = NO;
    }
    NSLog(@"xxxxx alpha %f", shadowView.alpha);
    shadowView.alpha = alpha;

    if (shadowView.alpha == 0) {
        shadowView.hidden = YES;
    }
}

-(void)filterBG:(float)alpha duration:(float)time {
    
    [UIView animateWithDuration:time animations:^{
        shadowView.alpha = alpha;
    } completion:^(BOOL isfinished){
        if (shadowView.alpha == 0.0f) {
            shadowView.hidden = YES;
        }
        
    }];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)switchView {
    
    [self cancelShowSelectors];
    if (!backTapped) {
        if (MVPlayer.playbackState == MPMoviePlaybackStatePlaying){
            [self performSelector:@selector(hideView:) withObject:controlView afterDelay:2.5];
            [self performSelector:@selector(showView:) withObject:triggerView afterDelay:2.5];
        }
    }
    
    if (viewSwitchBtn.tag == 1) {
        viewSwitchBtn.tag = 2;
        [viewSwitchBtn setImage:[UIImage imageNamed:@"7switchbutton_vedio@2x.png"] forState:UIControlStateNormal];
        
        Exercise * ex = [choosenExs objectAtIndex:index];
        [[VTracker tracker] registerEX:@"SWITCHTOREAD" with:ex.exName happensin:MVPlayer.currentPlaybackTime];
    }
    else {
        viewSwitchBtn.tag = 1;
        [viewSwitchBtn setImage:[UIImage imageNamed:@"7switchbutton_text@2x.png"] forState:UIControlStateNormal];
        
    }
    
    [mView doUIViewAnimation];
}

-(IBAction)switchRead {
   
}

#pragma mark Audio Delegate


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"BeginInterruption");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    NSLog(@"EndInterruption");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    NSLog(@"Interuption For Stop");
}

-(IBAction)share:(id)sender {
    UIActionSheet *option=[[[UIActionSheet alloc]initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle: nil
                                            otherButtonTitles:@"新浪微博",@"微信朋友圈",@"微信对话",
                           nil] autorelease];
    option.tag = 1000;
    [option showInView:self.view];
}




-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"response is %@",response);
    UIAlertView *alertView;
    [_activityIndicatorView stopAnimating];
    if (response.responseCode == UMSResponseCodeSuccess) {
        if (response.responseType == UMSResponseShareToSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是数据级的发送微博接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }
        if (response.responseType == UMSResponseShareToMutilSNS) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                alertView = [[UIAlertView alloc] initWithTitle:@"成功" message:@"亲，您刚才调用的是发送到多个微博平台的数据级接口，如果要获取发送状态需要像demo这样实现回调方法~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                SAFE_ARC_RELEASE(alertView);
            }
        }
    }
    else {
        alertView = [[UIAlertView alloc] initWithTitle:@"失败" message:@"亲，您刚才调用的发送微博接口发送失败了，具体原因请看到回调方法response对象的responseCode和message~" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
        SAFE_ARC_RELEASE(alertView);
    }
}

#pragma mark - UMSocialUIDelegate
-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType

{
    
    [sdView setHidden:NO];
    [fsVC.view setHidden:NO];
    [sp setHidden:YES];
    NSLog(@"didCloseUIViewController with type is %d",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    
    [sdView removeFromSuperview];
    [acVC.view removeFromSuperview];
    [fsVC.view removeFromSuperview];
    [sp removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}


- (void)actionSheet:(UIActionSheet *)actionSheet
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:{ //WEIBO
            
            Exercise * ex = [choosenExs objectAtIndex:index];
            [[VTracker tracker] registerEX:@"SHAREWB" with:ex.exName happensin:1000];
            
            [sdView setHidden:YES];
            [fsVC.view setHidden:YES];
            [sp setHidden:YES];
            UINavigationController *shareEditController = [_socialController getSocialShareEditController:UMSocialSnsTypeSina];
            [self presentModalViewController:shareEditController animated:YES];
            break;
        }
        case 1:{ //WEXINPY
            
            Exercise * ex = [choosenExs objectAtIndex:index];
            [[VTracker tracker] registerEX:@"SHAREWXPY" with:ex.exName happensin:1000];
            
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                
                SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
                WXMediaMessage * message = [WXMediaMessage message];
                WXImageObject *ext = [WXImageObject object];
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"social1" ofType:@"png"];
                ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
                WXWebpageObject *url=[[[WXWebpageObject alloc]init] autorelease];
                [url setWebpageUrl:@"https://itunes.apple.com/cn/app/yong-bao-qing-chun-dong-dong/id556483948?ls=1&mt=8"];
                message.mediaObject = ext;
                [message setThumbImage:[UIImage imageNamed:@"Icon-iPad.png"]];
                [message setTitle:@"我正在使用永葆青春动动操，有效利用碎片时间，随时随地进行运动，可以骨正筋柔，气血自流。你也来试试吧！"];
                [message setDescription:@"https://itunes.apple.com/cn/app/yong-bao-qing-chun-dong-dong/id556483948?ls=1&mt=8"];
                [message setMediaObject:url];
                req.message = message;
                req.bText = NO;
                
                req.scene = WXSceneTimeline;
                [WXApi sendReq:req];
            }
            else{
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil] autorelease];
                [alertView show];
            }
            break;
        }
            
        case 2:{ // WEIXINDUIHUA
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                
                SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
                // req.text = @"https://itunes.apple.com/cn/app/yong-bao-qing-chun-dong-dong/id556483948?ls=1&mt=8";
                
                Exercise * ex = [choosenExs objectAtIndex:index];
                [[VTracker tracker] registerEX:@"SHAREWXPY" with:ex.exName happensin:1000];
                
                
                // 下面实现图片分享，只能分享文字或者分享图片，或者分享url，里面带有图片缩略图和描述文字
                WXMediaMessage * message = [WXMediaMessage message];
                WXImageObject *ext = [WXImageObject object];
                NSString *filePath = [[NSBundle mainBundle] pathForResource:@"social1" ofType:@"png"];
                ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
                WXWebpageObject *url=[[[WXWebpageObject alloc]init] autorelease];
                [url setWebpageUrl:@"https://itunes.apple.com/cn/app/yong-bao-qing-chun-dong-dong/id556483948?ls=1&mt=8"];
                message.mediaObject = ext;
                [message setThumbImage:[UIImage imageNamed:@"Icon-iPad.png"]];
                [message setTitle:@"我正在使用永葆青春动动操，有效利用碎片时间，随时随地进行运动，可以骨正筋柔，气血自流。你也来试试吧！"];
                [message setDescription:@"https://itunes.apple.com/cn/app/yong-bao-qing-chun-dong-dong/id556483948?ls=1&mt=8"];
                [message setMediaObject:url];
                req.message = message;
                req.bText = NO;
                
                
                
                req.scene = WXSceneSession;
                
                // req.scene = WXSceneTimeline;
                
                [WXApi sendReq:req];
            }
            else{
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有安装微信" delegate:nil cancelButtonTitle:@"好" otherButtonTitles: nil] autorelease];
                [alertView show];
            }
            
            break;
        }
            
        default:{
            [sdView setHidden:NO];
            [fsVC.view setHidden:NO];
            [sp setHidden:YES];
            break;
        }
    }
    
    
}
@end
