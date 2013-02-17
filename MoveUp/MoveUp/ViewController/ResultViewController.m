//
//  ResultViewController.m
//  TestUI
//
//  Created by Ye Ke on 9/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "ResultViewController.h"
#import "AppDelegate.h"

@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize sendBtn;
@synthesize cancelBtn;
@synthesize postParams;
@synthesize imageData;
@synthesize imageConnection;
@synthesize pgView;
@synthesize textView;


-(IBAction)cancel:(id)sender{
    [self.view removeFromSuperview];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    // A more complex app might check the state to see what the appropriate course of
    // action is, but our needs are simple, so just make sure our idea of the session is
    // up to date and repopulate the user's name and picture (which will fail if the session
    // has become invalid).
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
                
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [textView becomeFirstResponder];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav_down.png"] forState:UIControlStateHighlighted];
    [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = menuBarItem;
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"9send.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"9send_down.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(publishStory)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *submitBarItem =[[UIBarButtonItem alloc] initWithCustomView:submitButton];
    
    self.navigationItem.rightBarButtonItem = submitBarItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                    name:@"com.facebook.hkmoveup:SCSessionStateChangedNotification"
                                               object:nil];
    
    self.imageData = [[NSMutableData alloc]init];
    NSURLRequest * imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/img/baidu_jgylogo3.gif"]];
    
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:imageRequest delegate:self];
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://itunes.apple.com/hk/app/yong-bao-qing-chun-dong-dong/id565843279?ls=1&mt=8",@"link",
     @"http://a725.phobos.apple.com/us/r30/Purple/v4/23/f7/b7/23f7b784-4e73-d19c-1e11-23d385dc3fe2/mzl.heuanluy.png",@"picture",
     @"永葆青春動動操",@"name",
     @"Build great social apps and get more installs,",@"caption",
     @"The facebook SDK for IOS makes it easier and faster to develop Facebook!",@"description",
     nil];
}

-(void)showMenu {
     [textView resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
}

-(void)publishStory{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
