//
//  IllustrationView.h
//  TestUI
//
//  Created by Ye Ke on 2/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
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
/*
 Used For Illustration
*/

typedef enum {
    kAtUpSide,
    kAtDownSide,
}sideStatus;

@protocol IllustrateViewDelegate

-(void)continuePlay;
-(void)stopPlay;
-(void)decreaseVolume;
-(void)filterBG:(float)alpha duration:(float)time;
-(void)filterBG:(float)alpha;
-(void)controlVolume:(BOOL)isdown;

@end


@interface IllustrationView : UIView<AVAudioPlayerDelegate> {
    
    IBOutlet UIScrollView * showView;
    IBOutlet UIImageView * acuView;
    IBOutlet UIButton * controlBtn;
    IBOutlet UILabel * acuTitle;
    IBOutlet UITextView * accuwdView;
    IBOutlet UILabel * wordTitle;
    IBOutlet UITextView * wordView;
    IBOutlet UILabel * effectTitle;
    IBOutlet UITextView * effectView;
    
    AVAudioPlayer		* hintPlayer;
    
    id<IllustrateViewDelegate> delegate;
    float heightDiff;
    sideStatus status;
    BOOL isBusy;
    BOOL isFirstTime;
    BOOL disrupted;
    BOOL receiveTouchEnabled;
    BOOL firstIndicationShowing;
    BOOL isPulledByUser;
    
    float boardLower;
    float boardUpper;
    float boardCenter;
}

@property (nonatomic, assign) BOOL isBusy;
@property (nonatomic, retain) IBOutlet UIScrollView * showView;
@property (nonatomic, retain) IBOutlet UITextView * wordView;
@property (nonatomic, retain) IBOutlet UIImageView * acuView;
@property (nonatomic, retain) IBOutlet UILabel * acuTitle;
@property (nonatomic, retain) IBOutlet UITextView * accuwdView;
@property (nonatomic, retain) IBOutlet UILabel * wordTitle;
@property (nonatomic, retain) IBOutlet UILabel * effectTitle;
@property (nonatomic, retain) IBOutlet UITextView * effectView;

@property (nonatomic, retain) IBOutlet UIButton * controlBtn;
@property (nonatomic, retain) IBOutlet AVAudioPlayer *hintPlayer;
@property (nonatomic, assign) IBOutlet id<IllustrateViewDelegate> delegate;
@property (nonatomic, assign) sideStatus status;
@property (nonatomic, assign) BOOL disrupted;
@property (nonatomic, assign) BOOL receiveTouchEnabled;
@property (nonatomic, assign) BOOL firstIndicationShowing;
@property (nonatomic, assign) BOOL isPulledByUser;


-(void)setContent:(Exercise *)ex;
-(void)stopPlayer;
-(void)popoutALittle;
-(void)popbackALittle;
-(void)goUp;
-(void)goDown;
@end
