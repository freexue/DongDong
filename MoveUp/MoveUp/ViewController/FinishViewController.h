//
//  FinishViewController.h
//  TestUI
//
//  Created by Ke Ye on 9/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AchieveViewController.h"
#import "UMSocialControllerService.h"
#import <CoreLocation/CoreLocation.h>


@protocol finishDelegate <NSObject>

-(void)finishExcercise;

-(void)goshare;

@end

@interface FinishViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource,
UIActionSheetDelegate,
UMSocialDataDelegate,
UMSocialUIDelegate
>
{
    
    UITableView *_shareTableView;
    UMSocialControllerService *_socialController;
    UIActionSheet *_editActionSheet;
    UIActionSheet *_dataActionSheet;
    UIImageView *_imageView;
    CLLocationManager *_locationManager;
    UIActivityIndicatorView * _activityIndicatorView;
    
    id<finishDelegate> delegate;
    IBOutlet UIButton * finishBtn;
}

@property (nonatomic, retain) IBOutlet UIButton * finishBtn;
@property (nonatomic, retain) id<finishDelegate> delegate;

-(void)showUp;
-(void)showUp:(AchieveViewController *)ac;

@end
