//
//  AssesViewController.h
//  TestUI
//
//  Created by Ke Ye on 8/6/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMProgressView.h"
#import "UserData.h"
#import "CrusierView.h"
#import "NoticeViewController.h"
#import "DescriptionView.h"
#import "LoadingView.h"

@class FlipView;
@class AnimationDelegate;
@interface AssesViewController : UIViewController<NoticeViewDelegate>{

    
    IBOutlet UIImageView * head;
    IBOutlet UIImageView * neck;
    IBOutlet UIImageView * shoulder;
    IBOutlet UIImageView * back;
    IBOutlet UIImageView * waist;
    IBOutlet UIImageView * butt;
    IBOutlet UIImageView * wrist;
    IBOutlet UIImageView * leg;
    
    
    UIImageView * maskView;
    UIImageView * shadow;
    NSTimer *timer;
    NSTimer *rugularTimer;
    IBOutlet UIView * tipsview;
    IBOutlet UIImageView * timeDigit1;
    IBOutlet UIImageView * timeDigit2;
    IBOutlet UIImageView * timeDigit3;

    IBOutlet UILabel *tipscontent;
     IBOutlet UIButton *goNext;
    StartStatus status;
    CrusierView * crView;
    
    float proCount;
    
    IBOutletCollection(UIButton) NSArray *partsButtons;
    IBOutletCollection(UIImageView) NSArray *partsFlashButtons;
    
    DescriptionView *description;
    BOOL isPress;
    BOOL isRate;
    BOOL isUpdate;
    
    NoticeViewController * gorate;
    NoticeViewController * goupdate;
    LoadingView *loading;
}
@property (nonatomic, retain) LoadingView *loading;
@property (nonatomic, retain)  IBOutlet UIButton *goNext;
@property (nonatomic, assign)  BOOL isPress;
@property (nonatomic, assign)  BOOL isRate;
@property (strong, nonatomic) DescriptionView *description;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *partsButtons;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *partsFlashButtons;
@property (nonatomic, assign) StartStatus status;

@property (nonatomic, retain) IBOutlet UILabel *tipscontent;
@property (nonatomic, retain) IBOutlet UIImageView * shadow;
@property (nonatomic, retain)     UIView * tipsview;


@property(nonatomic,retain) IBOutlet UIImageView * head;
@property(nonatomic,retain) IBOutlet UIImageView * neck;
@property(nonatomic,retain) IBOutlet UIImageView * shoulder;
@property(nonatomic,retain) IBOutlet UIImageView * back;
@property(nonatomic,retain) IBOutlet UIImageView * waist;
@property(nonatomic,retain) IBOutlet UIImageView * butt;
@property(nonatomic,retain) IBOutlet UIImageView * wrist;
@property(nonatomic,retain) IBOutlet UIImageView * leg;

@property(nonatomic,retain) IBOutlet UIImageView * bodyBg;

@property(nonatomic, retain) AMProgressView * pgView;

@property(nonatomic,retain)  IBOutlet UIImageView * timeDigit1;
@property(nonatomic,retain)  IBOutlet UIImageView * timeDigit2;
@property(nonatomic,retain)  IBOutlet UIImageView * timeDigit3;


-(IBAction)goNext:(id)sender;
-(IBAction)closeTips:(id)sender;
-(IBAction)showDiscription:(id)sender;
-(IBAction)hideDiscription:(id)sender;

@end
