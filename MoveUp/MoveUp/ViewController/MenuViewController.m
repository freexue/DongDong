//
//  MenuViewController.m
//  TestUI
//
//  Created by Ke Ye on 8/1/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "InfoViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

#import "ManageViewController.h"
#import "UserData.h"
#import "Data.h"
#import "Reachability.h"
#import "MobClick.h"
#import "FeedBackViewController.h"
#import "NotificationSettingViewController.h"
#import "ExercisePicker.h"

#define useAppkey @"503ae57d5270151fd700000e"
@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize menuCell;
@synthesize adBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        dataSource = [[NSMutableArray alloc]init];
        NSString * title;
        for (int i = 0; i< 6; i++) {
            
            if (i==0) {
                title = @"个人主页";
            }
            else if(i==1) {
                title = @"编辑资料";
            }
            else if(i==2) {
                title = @"设置推送";
            }
            
            
            else if(i==3) {
                title = @"意见反馈";
            }
            
            else if(i==4){
                title = @"给我评分";
            }
            
            else if(i==5){
                title = @"清除档案";
            }
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setObject:title forKey:@"title"];
            [dataSource addObject:dictionary];

        }
    }
    return self;
}

- (IBAction)gotoAd:(id)sender{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id537591213?mt=8#"]];  
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _tableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"6nav_background@2x.png"]];
    
    NSLog(@"ViewDIDLOAD");
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
     [menuButton release];
    self.navigationItem.leftBarButtonItem = menuBarItem;
    
    [menuBarItem release];
   
   
}


- (void)sessionStateChanged:(NSNotification*)notification {
    // A more complex app might check the state to see what the appropriate course of
    // action is, but our needs are simple, so just make sure our idea of the session is
    // up to date and repopulate the user's name and picture (which will fail if the session
    // has become invalid).
    //[self populateUserDetails];
    [self showModalPanel:nil];
}

-(void)showMenu {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //return 200 - _tableView.contentOffset.y;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Count %d", [dataSource count]);
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
    
    MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell==nil) {
        //最关键的就是这句。加载自己定义的nib文件
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CellView-568h" owner:self options:nil];
        //此时nib里含有的是组件个数
        if ([nib count]>0) {
            cell=self.menuCell;
        }
    }
    
    NSDictionary *dictionary = [dataSource objectAtIndex:indexPath.row];
    NSString *title = [dictionary objectForKey:@"title"];
    
    cell.titleLbl.text = title;

    return cell;
}


const int AssesIndex = 0;
const int BodyIndex = 1;
const int SettingIndex = 2;
const int FeedBackIndex = 3;
const int RateIndex = 4;
const int ClearIndex = 5;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([indexPath row] == AssesIndex) {
        AssesViewController * vc = [self isContainedInWithClass:[AssesViewController class]];
        
          if (vc != nil) {
              [appDelegate.NavFirstVC popToViewController:(UIViewController *)vc animated:NO];
              [appDelegate switchView:nil];
          }
        
          else {
              vc = [[AssesViewController alloc]initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
              
              [appDelegate switchView:vc];
          }
    }
    
    else if([indexPath row]==BodyIndex){
        
        DetailViewController * vc = [self isContainedInWithClass:[DetailViewController class]];
        
        vc = [[DetailViewController alloc]initWithNibName:XIBNameFor(@"DetailViewController") bundle:nil];
        [appDelegate switchView:vc];
    }
    
    else if([indexPath row]==SettingIndex){
        
        NotificationSettingViewController * vc = [self isContainedInWithClass:[NotificationSettingViewController class]];
        if (vc != nil) {
            [appDelegate.NavFirstVC popToViewController:(UIViewController *)vc animated:NO];
            [appDelegate switchView:nil];
            
        }
        else {
            
            vc = [[NotificationSettingViewController alloc]initWithNibName:XIBNameFor(@"NotificationSettingViewController") bundle:nil];
            [appDelegate switchView:vc];
        }
    }
    
    else if([indexPath row]==RateIndex){
        int m_appleID= 556483948;
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                         m_appleID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }
    
    else if([indexPath row]== ClearIndex){
     
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"确定要清除所有数据吗？所有资料需要重新设置" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"不要" 
                                                 otherButtonTitles:@"确定",nil];
        
        alertView.tag = 100;
        alertView.delegate=self;
        [alertView show];
        [alertView release];
        
           }
    else { //4
        
        FeedBackViewController * vc = [self isContainedInWithClass:[FeedBackViewController class]];
        
        if (vc != nil) {
            [appDelegate.NavFirstVC popToViewController:(UIViewController *)vc animated:NO];
            [appDelegate switchView:nil];
            
        }
        else {
            
            vc = [[FeedBackViewController alloc]initWithNibName:XIBNameFor(@"FeedbackViewController") bundle:nil];
            [appDelegate switchView:vc];
        }
    }
}

- (IBAction)showModalPanel:(id)sender {
	
    resultViewController = [[ResultViewController alloc]initWithNibName:@"ResultView" bundle:nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate switchView:resultViewController];
}


#pragma AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    
    if(buttonIndex == 1) {
        
        UIApplication *app = [UIApplication sharedApplication];
        [app cancelAllLocalNotifications];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[UserData sharedUser] resetUser];
        [Data emptytable];
        [ExercisePicker moveDoc];
        [[UserData sharedUser] importUser];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"excerciseFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"InNotification"];
        
        DetailViewController * bodyVC;
        
        bodyVC = [[DetailViewController alloc]initWithNibName:XIBNameFor(@"DetailViewController") bundle:nil];
        
        [appDelegate switchView:bodyVC];
        [bodyVC release];
        
        }
}

-(id)isContainedInWithClass:(Class)class {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray * arr = appDelegate.NavFirstVC.viewControllers;
    
    for (id vc in arr) {
        if ([vc isKindOfClass:class]) {
            [vc removeFromParentViewController];
        }
    }
    return nil;
}


#pragma Rating & Network & Sharing

- (BOOL)isNetWork
{
    BOOL reachability;
    Reachability *reach = [Reachability reachabilityWithHostName:@"202.108.22.5"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
          
            reachability = NO;
            return reachability;
            break;
        case ReachableViaWWAN:
        
            reachability = YES;
            return reachability;
            break;
        case ReachableViaWiFi:
            
            reachability = YES;
            return reachability;
            break;
            
        default:
            break;
    }
    
    return reachability;
}


-(void)ShowRating {
    BOOL reachability = [self isNetWork];
    if (reachability) {
        int m_appleID= 565843279;
        NSString *str = [NSString stringWithFormat: 
                         @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", 
                         m_appleID];  
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

-(void)ShowWeibo {
    BOOL reachability = [self isNetWork];
    if (reachability) {
        NSString *str = [NSString stringWithFormat:
                         @"http://www.weibo.com/freexuestudio"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


@end
