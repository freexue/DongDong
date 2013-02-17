//
//  FeedBackViewController.m
//  TestUI
//
//  Created by Ke Ye on 9/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "FeedBackViewController.h"
#import "AppDelegate.h"


@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
@synthesize textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = menuBarItem;
    
    [menuButton release];
    [menuBarItem release];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    
    
    [submitButton setBackgroundImage:[UIImage imageNamed:@"0submit@2x.png"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageNamed:@"0submit_down@2x.png"] forState:UIControlStateHighlighted];
    [submitButton addTarget:self action:@selector(goSubmit)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *submitBarItem =[[UIBarButtonItem alloc] initWithCustomView:submitButton];
    
    self.navigationItem.rightBarButtonItem = submitBarItem;

    [submitButton release];
    [submitBarItem release];
    
    self.navigationItem.title = @"意见反馈";
    textView.delegate = self;
    [textView becomeFirstResponder];
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

#pragma mark UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)ttextView
{
    textView.text = @"";
}

-(void)goSubmit {
    
    time_t now;
    time(&now);
    NSDate *_dateline = [NSDate dateWithTimeIntervalSince1970:now];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * new = [dateformat stringFromDate:_dateline];
    [dateformat release];
    
    NSLog(@"now time = %@",new);
    
    NSString * str = [NSString stringWithFormat:@"%@-Time:%@", textView.text,new];
    int sex = 1;
    NSString * sexStr = [NSString stringWithFormat:@"%d", sex];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          sexStr, @"UMengFeedbackGender", @"2",@"UMengFeedbackAge", str,@"UMengFeedbackContent",nil];
    [MobClick feedbackWithDictionary:dict];
    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:@"发送成功！"
                                                      delegate:nil
                                             cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

-(void)showMenu {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [textView resignFirstResponder];
    [appDelegate cancel];
    
}

@end
