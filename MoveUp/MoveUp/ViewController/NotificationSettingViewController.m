//
//  NotificationSettingViewController.m
//  TestUI
//
//  Created by FreeXue on 13-1-5.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import "NotificationSettingViewController.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "VTracker.h"
#import "NotificationManager.h"


#define kHourComponent 0
#define kMinutesComponent 1

@interface NotificationSettingViewController ()

@end

@implementation NotificationSettingViewController
@synthesize listData;
@synthesize listData1;
@synthesize infoData;
@synthesize _tableView;
@synthesize scrollview;
@synthesize efButton;
@synthesize btnswith;
@synthesize finishsetting;
@synthesize hourArr;
@synthesize minutesArr;
@synthesize notis;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    NSLog(@"NotificationSetting DEALOOC");
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[VTracker tracker] recountViewTime];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[VTracker tracker] registerLT:@"NOTIVIEW"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hourArr = [NSArray arrayWithObjects:@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    self.minutesArr = [NSArray arrayWithObjects:@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55",nil];
    
    //Initializing Data Storage Variables
    self.notis = [UserData sharedUser].notiArr;
    
     NSLog(@"%@",notis);
    weekdays = [UserData sharedUser].weekDays;
    /////
    btnswith=NO;
    finishsetting= [[UIButton alloc] initWithFrame:CGRectMake(100, 450+listData.count*44, 110, 40)];
    [finishsetting setBackgroundImage:[UIImage imageNamed:@"0button_long@2x.png"] forState:UIControlStateNormal];
    [finishsetting setBackgroundImage:[UIImage imageNamed:@"0button_long_down@2x.png"] forState:UIControlStateHighlighted];
    [finishsetting setTitle:@"完成！进入主页" forState:UIControlStateNormal];
    [finishsetting setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    finishsetting.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [scrollview addSubview:finishsetting];
    [finishsetting addTarget:self action:@selector(goMain)forControlEvents:UIControlEventTouchUpInside];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]) {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem = menuBarItem;
       
        [menuButton release];
        [menuBarItem release];
        
        finishsetting.hidden=YES;
    }
    else{
        self.navigationItem.hidesBackButton=YES;
    }
    efButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    [efButton setBackgroundImage:[UIImage imageNamed:@"0edit.png"] forState:UIControlStateNormal];
    [efButton setBackgroundImage:[UIImage imageNamed:@"0edit_down.png"] forState:UIControlStateHighlighted];
    [efButton addTarget:self action:@selector(goEdit)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *submitBarItem =[[UIBarButtonItem alloc] initWithCustomView:efButton];
    self.navigationItem.rightBarButtonItem = submitBarItem;
    
    [submitBarItem release];
    
    self.navigationItem.title = @"推送设置";
    
    [self setListDataByNotiArr];
    
    self.listData1 =[[[NSArray alloc] initWithObjects:@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期天",nil] autorelease];
    
    self.infoData = [[NSMutableArray alloc] initWithObjects:self.listData,self.listData1, nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
    [self settingViewSize];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
        //选取哪天需要做操
        
        if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
            oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [weekdays replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithInt:1]];
            [NotificationManager resetNotifications];
        }
        else{
            int flag=0;
            for (int i=0; i<weekdays.count; i++) {
                if ([[weekdays objectAtIndex:i] intValue]!=0) {
                    flag++;
                }
            }
            if (flag>=2) {
                oneCell.accessoryType = UITableViewCellAccessoryNone;
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [weekdays replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithInt:0]];
                [NotificationManager resetNotifications];
            }
        }
    }
    
    else{ // NotiTime
        if (indexPath.row == listData.count-1) {
            //触发添加的按钮 这个时候需要弹出 picker view=======设置好之后按一下内容添加
            [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260 , 320, 260)];
            notiAction = AddNoti;
            modifying_noti_index = -1;
        }
        else{
            [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260 , 320, 260)];
            
         UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
            [picker selectRow:[self getIndex:oneCell.textLabel.text part:0] inComponent:0 animated:YES];
            [picker selectRow:[self getIndex:oneCell.textLabel.text part:1] inComponent:1 animated:YES];
            notiAction = UpdateNoti;
            modifying_noti_index = indexPath.row;
        }
    }
}
-(int)getIndex:(NSString *)text part:(int)component{
    if (component==0) {
       return  [[text substringToIndex:2] intValue]-6;
    }
    else{

        return  [[text substringFromIndex:3] intValue]/5;
    }

}
-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section{
    return [[self.infoData objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.infoData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell==nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:showUserInfoCellIdentifier]
                autorelease];
    }
    if (indexPath.section==0) {
        if (indexPath.row == self.infoData.count - 1) {
            
            cell.accessoryType = UITableViewCellSelectionStyleNone;
        }
        else{
            cell.accessoryType =  UITableViewCellSelectionStyleNone;
        }
    }
    else
    {
        if ([[weekdays objectAtIndex:indexPath.row] intValue] == 0) {
            cell.accessoryType =  UITableViewCellAccessoryNone;
        }
        else
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    //Add Notification Name
    
    [[cell textLabel] setText:[[self.infoData objectAtIndex:indexPath.section] objectAtIndex: indexPath.row]];
    
    [cell textLabel].font = [UIFont fontWithName:@"Arial" size:16];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"时间设置";
    }
    else{
        return @"日期设置";
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section==0) {
        return @"至少要保留一次推送时间";
    }
    else{
        return  @"每周至少要保留一天推送";

    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置第一个和最后一个选项不可删除
    if (indexPath.section==0&&([listData count]!=2&&indexPath.row!=[listData count]-1)) {
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除选中行
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger row = [indexPath row];
        [listData removeObjectAtIndex:row];   // 从数组中删除对应的数据
        [notis removeObjectAtIndex:row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
        [NotificationManager resetNotifications];
        [self settingViewSize];
        if (listData.count<=2) {
            [tableView setEditing:NO animated:YES];
            [efButton setBackgroundImage:[UIImage imageNamed:@"0edit.png"] forState:UIControlStateNormal];
            [efButton setBackgroundImage:[UIImage imageNamed:@"0edit_down.png"] forState:UIControlStateHighlighted];
            efButton.hidden=YES;
        }
        else{
            
        }
    }
    if(editingStyle==UITableViewCellEditingStyleInsert){
    }
}


//==========

-(void)goEdit{
    
    if (btnswith==YES) {
        btnswith=NO;
        [_tableView setEditing:NO animated:YES];
        [efButton setBackgroundImage:[UIImage imageNamed:@"0edit.png"] forState:UIControlStateNormal];
        [efButton setBackgroundImage:[UIImage imageNamed:@"0edit_down.png"] forState:UIControlStateHighlighted];
        
    }
    else {
        btnswith=YES;
        if (listData.count>2) {
            [_tableView setEditing:YES animated:YES];
            [efButton setBackgroundImage:[UIImage imageNamed:@"0finish.png"] forState:UIControlStateNormal];
            [efButton setBackgroundImage:[UIImage imageNamed:@"0finish_down.png"] forState:UIControlStateHighlighted];
        }
    }
    
}


-(IBAction)cancel:(id)sender{
    [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height  , 320, 260)];
}

-(IBAction)finishNotiSet:(id)Sender {
    
    [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height  , 320, 260)];
    
    if (modifying_noti_index == -1) {
        
        NSNumber * notiTime = [self fetchPickerData];
        Boolean needUpdate = true;
        int i = 0;
        for (i = 0; i < [notis count]; i++) {
            
            NSNumber * num = [notis objectAtIndex:i];
            NSLog(@"i : %d  num %d  notiTime %d", i, [num intValue], [notiTime intValue]);
            if ([notiTime intValue] < [num intValue]) {
                [notis insertObject:notiTime atIndex:i];
                NSLog(@"Com In");
                break;
            }
            else if ([notiTime intValue] == [num intValue]) {
                needUpdate = false;
                //Other Operations Like Tips: Same Time!
                break;
            }
            
           else if (i == [notis count] - 1) {
                [notis insertObject:notiTime atIndex:i+1];
                i ++ ;
                break;
            }
        }
        
        if (needUpdate) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            NSInteger row = [indexPath row];
            NSArray *insertIndexPath = [NSArray arrayWithObjects:indexPath, nil];
            
            int val = [notiTime intValue];
            NSString * armyTime = [NSString stringWithFormat:@"%d", val];
            NSString * displayedTime;
            if (val >= 1000) {
                displayedTime = [NSString stringWithFormat:@"%@:%@", [armyTime substringToIndex:2],[armyTime substringFromIndex:2]];
            }
            else {
                displayedTime = [NSString stringWithFormat:@"0%@:%@", [armyTime substringToIndex:1],[armyTime substringFromIndex:1]];
            }
            
            [self.listData insertObject:displayedTime atIndex:row];
            
            [_tableView beginUpdates];
            //[self setListDataByNotiArr];
            [self._tableView insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationRight];
            
            [self._tableView endUpdates];
            efButton.hidden=NO;
            [self settingViewSize];
            
            [NotificationManager resetNotifications];
        }
        else {
            NSLog(@"无法添加：该时间已经存在");
        }
        
    }
    else{
        
        NSNumber * notiTime = [self fetchPickerData];
        Boolean needUpdate = true;
        int i = 0;
        for (i = 0; i < [notis count]; i++) {
            
            NSNumber * num = [notis objectAtIndex:i];
            NSLog(@"i : %d  num %d  notiTime %d", i, [num intValue], [notiTime intValue]);
            if ([notiTime intValue] == [num intValue]) {
                needUpdate = false;
                //Other Operations Like Tips: Same Time!
                break;
            }
        }
        
        if (needUpdate) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:modifying_noti_index inSection:0];  
        int val = [notiTime intValue];
        NSString * armyTime = [NSString stringWithFormat:@"%d", val];
        NSString * displayedTime;
        if (val >= 1000) {
            displayedTime = [NSString stringWithFormat:@"%@:%@", [armyTime substringToIndex:2],[armyTime substringFromIndex:2]];
        }
        else {
            displayedTime = [NSString stringWithFormat:@"0%@:%@", [armyTime substringToIndex:1],[armyTime substringFromIndex:1]];
        }
         [self.notis replaceObjectAtIndex:indexPath.row withObject:notiTime];
            
            NSArray * arr =  [notis sortedArrayUsingComparator:^(id obj1, id obj2){
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    
                    return (NSComparisonResult)NSOrderedDescending;
                    
                }
                
                
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    
                    return (NSComparisonResult)NSOrderedAscending;
                    
                }
                
                
                
                return (NSComparisonResult)NSOrderedSame;
                
            }];
            
            self.notis= [NSMutableArray arrayWithArray:arr];
            

         [self.listData replaceObjectAtIndex:indexPath.row withObject:displayedTime];
            
          //[UserData sharedUser].notiArr=notis;
         [self setListDataByNotiArr];
            [self.infoData  replaceObjectAtIndex:0 withObject:self.listData];
            NSLog(@"%@",notis);
            NSLog(@"%@",self.infoData);
        [_tableView beginUpdates];
       
       // [self._tableView reloadRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationFade];
 
            NSIndexSet *indexset=[NSIndexSet indexSetWithIndex:0];
            [self._tableView reloadSections:indexset  withRowAnimation:UITableViewRowAnimationFade];
            [self.view setNeedsDisplay];
        [self._tableView endUpdates];
        [NotificationManager resetNotifications];
    }
        else {
            NSLog(@"无法添加：该时间已经存在");
        }
    }
}

-(void)settingViewSize{
    finishsetting.frame=CGRectMake(finishsetting.frame.origin.x, 500+listData.count*44, finishsetting.frame.size.width, finishsetting.frame.size.height);
    _tableView.contentSize=CGSizeMake(320, 400+listData.count*45);
    _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height+listData.count*50);
    scrollview.contentSize=CGSizeMake(320, 550+listData.count*45);
}
-(void)showMenu {
    [[UserData sharedUser] importUser];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
}


-(void)goMain {
    
    [[UserData sharedUser] importUser];
    
    [[VTracker tracker] packageUerInfo];
    [[VTracker tracker] sendOutData];
    
    AssesViewController * VC;
    VC = [[AssesViewController alloc]initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
    [self.navigationController pushViewController:VC animated:NO];
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:kCATransitionFade]; //淡入淡出pageCurl
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
}

#pragma mark Noti Time Setting

-(void)setListDataByNotiArr {
    self.listData =[[[NSMutableArray alloc] init] autorelease];
    
    for (NSNumber * noti in notis) {
        int val = [noti intValue];
        NSString * armyTime = [NSString stringWithFormat:@"%d", val];
        NSString * displayedTime;
        if (val >= 1000) {
            displayedTime = [NSString stringWithFormat:@"%@:%@", [armyTime substringToIndex:2],[armyTime substringFromIndex:2]];
        }
        else {
            displayedTime = [NSString stringWithFormat:@"0%@:%@", [armyTime substringToIndex:1],[armyTime substringFromIndex:1]];
        }
        
        [self.listData addObject:displayedTime];
    }
    [self.listData addObject:@"添加"];
    
}

-(void)setValue:(UIPickerView *)pickerView withData:(NSArray *)dataSource withComponent:(NSInteger)component with:(NSString *)value {
    
    for (int i= 0; i< [dataSource count]; i++) {
        NSString * data = [dataSource objectAtIndex:i];
        if ([data isEqualToString:value]) {
            [pickerView selectRow:i inComponent:component animated:NO];
        }
    }
    
}

-(void) setAnimatedFrame: (UIView *)view  with :(CGFloat) animateTime and: (CGRect)frame{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:animateTime];
    [view setFrame:frame];
    [UIView commitAnimations];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //NSNumber * number =  [self fetchPickerData];
    
    //Need To Modify
    
    /*[self.listData replaceObjectAtIndex:modifying_noti_index withObject:[self toTimeFormat:number]];
     [self._tableView reloadData];*/
}

-(NSString *)toTimeFormat:(NSNumber *)notiTime {
    int val = [notiTime intValue];
    NSString * armyTime = [NSString stringWithFormat:@"%d", val];
    NSString * displayedTime;
    if (val >= 1000) {
        displayedTime = [NSString stringWithFormat:@"%@:%@", [armyTime substringToIndex:2],[armyTime substringFromIndex:2]];
    }
    else {
        displayedTime = [NSString stringWithFormat:@"0%@:%@", [armyTime substringToIndex:1],[armyTime substringFromIndex:1]];
    }
    return displayedTime;
}

-(NSNumber *)fetchPickerData {
    NSUInteger numComponents = [picker.dataSource numberOfComponentsInPickerView:picker];
    
    int notiTime = 0;
    
    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger selectedRow = [picker selectedRowInComponent:i];
        NSString * title = [picker.delegate pickerView:picker titleForRow:selectedRow forComponent:i];
        NSLog(@"OTime: %@", title );
        if(i == kMinutesComponent){
            NSLog(@"=>Time: %@", title );
            notiTime += [title integerValue];
        }
        else {
            notiTime += [title integerValue] * 100;
        }
    }
    
    return [NSNumber numberWithInt:notiTime];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component == kMinutesComponent)
    {
        return [minutesArr count];
    }
    return [hourArr count];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(UIView *)pickerView:(UIPickerView *)pickerView
          titleForRow:(NSInteger)row
         forComponent:(NSInteger)component
{
    
    if(component == kMinutesComponent)
    {
        return [minutesArr objectAtIndex:row];
    }
    return [hourArr objectAtIndex:row];
    
}

@end
