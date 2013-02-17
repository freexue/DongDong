//
//  FinishViewController.m
//  TestUI
//
//  Created by Ke Ye on 9/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "FinishViewController.h"
#import "StarPanel.h"
#import "WXApi.h"
#import <MessageUI/MessageUI.h>
#import "UMSocialMacroDefine.h"


@interface FinishViewController ()

@end

@implementation FinishViewController
@synthesize finishBtn;
@synthesize delegate;


-(void)dealloc
{
    [_socialController.socialDataService setUMSocialDelegate:nil];
    SAFE_ARC_RELEASE(_socialController);
    SAFE_ARC_RELEASE(_editActionSheet);
    SAFE_ARC_RELEASE(_dataActionSheet);
    SAFE_ARC_RELEASE(_shareTableView);
    SAFE_ARC_RELEASE(_imageView);
    SAFE_ARC_RELEASE(_locationManager);
    SAFE_ARC_RELEASE(_activityIndicatorView);
    SAFE_ARC_SUPER_DEALLOC();
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        textLabel.numberOfLines = 4;
        textLabel.text = @"我正在使用#永葆青春动动操#，有效利用碎片时间，随时随地进行运动，可以骨正筋柔，气血自流。你也来试试吧！http://t.cn/zlRgv8j";
        //[self.view addSubview:textLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,90 , 150, 120)];
        NSString *imageName = [NSString stringWithFormat:@"social1.jpg"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showUp:(AchieveViewController *)acVC {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.3 animations:^{
            
        self.view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - acVC.view.frame.size.width)/2.0, ([UIScreen mainScreen].bounds.size.height)/2.0 - acVC.view.frame.size.height - 10, acVC.view.frame.size.width, acVC.view.frame.size.height);
            
        }completion:^(BOOL finished){
            [acVC showUp];
        }];
    }];
    [UIView commitAnimations];
}

-(void)showUp{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished){
    }];
    
    [UIView commitAnimations];
}

-(IBAction)finish:(id)sender {
    [delegate finishExcercise];
}


-(IBAction)share:(id)sender {
    [delegate goshare];
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
    NSLog(@"didCloseUIViewController with type is %d",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController is %@",response);
}

@end
