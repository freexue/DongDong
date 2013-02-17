//
//  PlayViewController.h
//  TestUI
//
//  Created by Ke Ye on 8/1/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "TriggerView.h"
#import "ReadingFile.h"
#import "Data.h"
#import "MixView.h"
#import "TouchTextView.h"
#import "ShadowView.h"
#import "FinishViewController.h"
#import "StarPanel.h"
#import "ExercisePicker.h"
#import "PileView.h"
#import "TouchView.h"
#import "AcupointView.h"
#import "LoadingView.h"
#import "UMSocialControllerService.h"
#import <CoreLocation/CoreLocation.h>
#import "IllustrationView.h"

#import <MediaPlayer/MediaPlayer.h>

@interface PlayViewController : UIViewController<AVAudioPlayerDelegate,touchDelegate, finishDelegate,UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UMSocialDataDelegate,
UMSocialUIDelegate,
touchVideoDelegate,
IllustrateViewDelegate>
{
    
    UITableView *_shareTableView;
    UMSocialControllerService *_socialController;
    UIActionSheet *_editActionSheet;
    UIActionSheet *_dataActionSheet;
    UIImageView *_imageView;
    CLLocationManager *_locationManager;
    UIActivityIndicatorView * _activityIndicatorView;
    LoadingView *loading;
    
    
    
    AVAudioPlayer		*player;
    AVAudioPlayer       *musicPlayer;  //Not Necessary Later Maybe
    
    IBOutlet UISlider * musicSlider;
    IBOutlet UIButton * controlBtn;
    IBOutlet UILabel * durationLbl;
    IBOutlet UILabel * durationLbl1;
    IBOutlet UIImageView * tips;
    IBOutlet IllustrationView * illuView;
    
    BOOL focused;
    NSMutableArray * fileArray;
    int index;
    
    NSTimer * timer;
    IBOutlet UIView * controlView;
    IBOutlet TriggerView * triggerView;
    Boolean hiddenstatus;
    
    StarPanel * sp;
    int duration;
    
    UIButton *backButton;
    
    Boolean needToChangeView;
    NSMutableArray * btns;
    NSMutableArray * exerciseOrders;
    Data * data;
    IBOutlet UILabel *numofmove;
    IBOutlet MixView * mView;
    IBOutlet UIButton * viewSwitchBtn;
    ShadowView * sdView;
    AchieveViewController * acVC;
    FinishViewController * fsVC;
    Boolean finished;
    NSTimer * volumeTimer;
    
    //-------New Vavirables-----
    PileView * pileView;
    NSMutableArray * choosenExs;
    MPMoviePlayerController * MVPlayer;
    IBOutlet AcupointView *draggedView;
    AVAudioPlayer * hintPlayer;
    IBOutlet UIButton * indicationBtn;
    IBOutlet UIImageView * shadowView;
    BOOL indicationHasAutoShowed;
    BOOL indicationHasAutoHided;
    
    BOOL isIndicationStored;
    BOOL backTapped;
}
@property (nonatomic, retain) LoadingView *loading;
@property (nonatomic, retain) IBOutlet UISlider * musicSlider;
@property (nonatomic, retain) IBOutlet UILabel *numofmove;
@property (nonatomic, retain) IBOutlet UIButton * controlBtn;
@property (nonatomic, retain) IBOutlet UIView * controlView;
@property (nonatomic, retain) IBOutlet TriggerView * triggerView;
@property (nonatomic, retain) IBOutlet MixView * mView;
@property (nonatomic, retain) IBOutlet UIButton * viewSwitchBtn;
@property (nonatomic, retain) IBOutlet UIImageView * tips;
@property (nonatomic, retain) IBOutlet PileView * pileView;
@property (nonatomic, retain) IBOutlet AcupointView *draggedView;
@property (nonatomic, retain) MPMoviePlayerController * MVPlayer;
@property (nonatomic, retain) IBOutlet IllustrationView * illuView;
@property (nonatomic) BOOL viewIsIn;

-(IBAction)share:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil and:(NSMutableArray *)exs;

-(void)showView:(UIView *)view;
-(void)hideView:(UIView *)view;
@end
