//
//  ManageViewController.m
//  TestUI
//
//  Created by Ke Ye on 8/6/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "ManageViewController.h"
#import "AppDelegate.h"
#import "ManageMenuCell.h"
#import "UserData.h"
#import "MobClick.h"


@interface ManageViewController ()
@end

@implementation ManageViewController
@synthesize manageCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [MobClick event:@"EnterMetalList"];
           }
    return self;
}

#pragma mark UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CustomCellIdentifier = @"CustomCellIdentifier2";
    
 
 
    ManageMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if (cell==nil) {
        //最关键的就是这句。加载自己定义的nib文件
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"ManageCellView-568h" owner:self options:nil];
        //此时nib里含有的是组件个数
        if ([nib count]>0) {
            cell=self.manageCell;
        }
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MedalList" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *arry=(NSArray *)[dictionary objectForKey:@"Medal"];
    
    [dictionary release];
    
    NSDictionary * dic = [arry objectAtIndex:indexPath.row];
    
    
    NSString * ImgName = [dic objectForKey:@"Image"];
    
    NSString * Title = [dic objectForKey:@"Title"];
    
    NSString * Intro = [dic objectForKey:@"Content"];
    
    UIImageView * metal=[[UIImageView alloc]initWithImage: [UIImage imageNamed:ImgName]];
    metal.frame = CGRectMake(14, 14, 72, 72);
     if ([[[UserData sharedUser].achievements objectAtIndex:indexPath.row] intValue]==0) {
        metal.alpha=0.1;
    }
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(108, 20, 120, 20)];
    title.text= Title;
    title.font = [UIFont systemFontOfSize:18];
    
    UILabel *intro=[[UILabel alloc]initWithFrame:CGRectMake(108, 40, 200, 50)];
    intro.text= Intro;
    intro.font = [UIFont systemFontOfSize:16];
    intro.lineBreakMode = UILineBreakModeWordWrap;  
    intro.numberOfLines = 0;
    
    cell.userInteractionEnabled = NO;
    [cell addSubview:metal];
    [cell addSubview:title];
    [cell addSubview:intro];
    
    [metal release];
    [title release];
    [intro release];
    
    if (cell == nil) {
        cell = [[[ManageMenuCell alloc]initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CustomCellIdentifier ] autorelease];
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.navigationItem.title=@"锻炼成就";
    self.navigationItem.leftBarButtonItem = menuBarItem;
    
    [menuButton release];
    [menuBarItem release];
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

@end
