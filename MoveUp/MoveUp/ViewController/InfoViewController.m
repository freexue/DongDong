//
//  InfoViewController.m
//  TestUI
//
//  Created by Ke Ye on 8/3/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "InfoViewController.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "MobClick.h"
#import "NotificationManager.h"

#define kMiniteComponent 0
#define kSecondComponent 1
@interface InfoViewController ()

@end

@implementation InfoViewController

@synthesize table;
@synthesize compLbl;
@synthesize compSlider;
@synthesize sitSlider;
@synthesize sitLbl;
@synthesize okBtn;
@synthesize cancelBtn;
@synthesize popUpView;
@synthesize picker;
@synthesize noti0Btn;
@synthesize noti1Btn;
@synthesize noti2Btn;
@synthesize scrollView;
@synthesize circuView;

@synthesize morningArr;
@synthesize noonArr;
@synthesize secondArr;
@synthesize pickerSource;
@synthesize type;

@synthesize male;
@synthesize female;
@synthesize selected;

@synthesize n1lb1;
@synthesize n1lb2;
@synthesize n2lb1;
@synthesize n2lb2;

@synthesize cirlb;
@synthesize circuBtn;

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
    // Do any additional setup after loading the view from its nib.
    
    [NotificationManager registerRegularNotification:6 and:2 of:MONDAY];
    
    if ([UserData sharedUser].gender == 1) {
        selected.frame=CGRectMake(102, 28, 60, 50);
    }
    else {
        selected.frame=CGRectMake(184, 28, 60, 50);
    }
   
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"0back@2x.png"] forState:UIControlStateNormal];
    //[backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBarItem =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backBarItem;
    self.navigationItem.title=@"编辑资料";
    
    [backBarItem release];
    [backButton release];
    
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 50, 30)];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"0finish.png"] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finish)forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *finishItem =[[UIBarButtonItem alloc] initWithCustomView:finishButton];
    
    self.navigationItem.rightBarButtonItem = finishItem;
    [finishButton release];
    [finishItem release];
    n1lb1.text = [[UserData sharedUser].noti1Time substringToIndex:2];
    n1lb2.text = [[UserData sharedUser].noti1Time substringFromIndex:2];

    n2lb1.text = [[UserData sharedUser].noti2Time substringToIndex:2];
    n2lb2.text = [[UserData sharedUser].noti2Time substringFromIndex:2];
    
    sitSlider.minimumValue = 2;
    sitSlider.maximumValue = 15;
  
    compSlider.minimumValue = 2;
    compSlider.maximumValue = 15;
    
    sitSlider.value = [UserData sharedUser].sittingTime;
    compSlider.value = [UserData sharedUser].compTime;
    
    sitLbl.text = [NSString stringWithFormat:@"%d", [UserData sharedUser].sittingTime];
    compLbl.text = [NSString stringWithFormat:@"%d", [UserData sharedUser].compTime];
    [sitSlider addTarget:self action:@selector(slideSit) forControlEvents:UIControlEventValueChanged];
    [compSlider addTarget:self action:@selector(slideComp) forControlEvents:UIControlEventValueChanged];
    //====edit by DT 2012.8.7
    [sitSlider setThumbImage:[UIImage imageNamed:@"3sitsliderpoint.png"] forState:UIControlStateNormal];
    [sitSlider setThumbImage:[UIImage imageNamed:@"3sitsliderpoint.png"] forState:UIControlStateHighlighted];
   if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    [sitSlider setMinimumTrackTintColor:[UIColor blueColor]];
    
    
    [compSlider setThumbImage:[UIImage imageNamed:@"3pcsliderpoint.png"] forState:UIControlStateNormal];
    [compSlider setThumbImage:[UIImage imageNamed:@"3pcsliderpoint.png"] forState:UIControlStateHighlighted];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
        [compSlider setMinimumTrackTintColor:[UIColor orangeColor]];
    
//    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"3sitslider_blue.png"]stretchableImageWithLeftCapWidth:80.0 topCapHeight:40.0];
  //  [sitSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    //======
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *plistURL = [bundle URLForResource:@"NotiTime" withExtension:@"plist"];
    
    NotiTimes = [NSDictionary dictionaryWithContentsOfURL:plistURL];
    state = unfocused;
    
    self.morningArr = [NSArray arrayWithObjects:@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    self.noonArr = [NSArray arrayWithObjects:@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",nil];
    self.secondArr = [NSArray arrayWithObjects:@"00",@"15",@"30",@"45",nil];
    self.type = [NSArray arrayWithObjects:@"工作日",@"每天",nil];
    
    self.pickerSource = self.morningArr;
    
    if ([UserData sharedUser].prohibit == 5) {
        cirlb.text = [self.type objectAtIndex:0];
    }
    else {
        cirlb.text = [self.type objectAtIndex:1];
    }
}

-(id)isContainedInWithClass:(Class)class {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray * arr = appDelegate.preVC.navigationController.viewControllers;
    
    for (id vc in arr) {
        if ([vc isKindOfClass:class]) {
            return vc;
        }
    }
    return nil;
}

-(void)back {
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finish {
    
    //Mark Log
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"免责声明"
                                                           message:@"本程序不适合手腕，颈椎和腰椎等骨骼受过外伤或者有相关骨骼疾病的患者，程序中的动作和方法仅作为日常生活的保健建议，如有身体不适请停止练习并向医生咨询" 
                                                          delegate:nil
                                                 cancelButtonTitle:@"不同意" 
                                                 otherButtonTitles:@"同意",nil];
        alertView.delegate=self;
        [alertView show];
        [alertView release];
    }
    else {
        
        [self statisitics];
        
        
    NSString * noti1Str = [NSString stringWithFormat:@"%@%@",n1lb1.text,n1lb2.text];
    NSString * noti2Str = [NSString stringWithFormat:@"%@%@",n2lb1.text,n2lb2.text];
        [UserData sharedUser].noti1Time = noti1Str;
    [UserData sharedUser].noti2Time = noti2Str;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
        if ([UserData sharedUser].prohibit == 7) {
            NSLog(@"PROHIBIT = 7");
            //[self makeNotification:n1lb1.text and:n1lb2.text andType:0];
            //[self makeNotification:n2lb1.text and:n2lb2.text andType:1];
        }
        else {
            NSLog(@"PROHIBIT = 5");
            //[self makeWeekNotification:n1lb1.text and:n1lb2.text andType:0];
            //[self makeWeekNotification:n2lb1.text and:n2lb2.text andType:1];
            
        }
       
    
    [UserData sharedUser].sittingTime = (int)sitSlider.value;
    [UserData sharedUser].compTime = (int)compSlider.value;
    
    
    [[UserData sharedUser] importUser];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AssesViewController * vc = [self isContainedInWithClass:[AssesViewController class]];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (vc != nil) {
        [appDelegate.preVC.navigationController popToViewController:(UIViewController *)vc animated:YES];
    }
    else {
        
        vc = [[AssesViewController alloc]initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
        }
    }
}

-(void)setValue:(UIPickerView *)pickerView withData:(NSArray *)dataSource withComponent:(NSInteger)component with:(NSString *)value {
    
    for (int i= 0; i< [dataSource count]; i++) {
        NSString * data = [dataSource objectAtIndex:i];
        if ([data isEqualToString:value]) {
            [pickerView selectRow:i inComponent:component animated:NO];
        }
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == circuView) {
        [self setCirType];
    }
    else {
        [self setData];
    }
}



-(UIView *)pickerView:(UIPickerView *)pickerView  
          titleForRow:(NSInteger)row  
         forComponent:(NSInteger)component  
{  
    
    if (pickerView == circuView) {
        return [self.type objectAtIndex:row];
    }
    else {
        if(component == kMiniteComponent)
        {
            return [self.pickerSource objectAtIndex:row];
        }
        return [self.secondArr objectAtIndex:row]; 
    }
} 
//Set The Label
- (void) setData{
    NSUInteger numComponents = [picker.dataSource numberOfComponentsInPickerView:picker];
    
    NSMutableString * text = [NSMutableString string];
    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger selectedRow = [picker selectedRowInComponent:i];
        NSString * title = [picker.delegate pickerView:picker titleForRow:selectedRow forComponent:i];
        if (state == onNoti1) {
            if(i == kMiniteComponent){
                n1lb1.text = [NSString stringWithFormat:@"%@", title];
            }
            else {
                n1lb2.text = [NSString stringWithFormat:@"%@", title];
            }
        }
        else if(state == onNoti2) {
            if(i == kMiniteComponent){
                n2lb1.text = [NSString stringWithFormat:@"%@", title];
            }
            else {
                n2lb2.text = [NSString stringWithFormat:@"%@", title];
            }
        }
    }
    NSLog(@"%@", text);
}

-(void) setCirType {
    NSUInteger numComponents = [circuView.dataSource numberOfComponentsInPickerView:circuView];
    
    for(NSUInteger i = 0; i < numComponents; ++i) {
        NSUInteger selectedRow = [circuView selectedRowInComponent:i];
        NSString * title = [circuView.delegate pickerView:circuView titleForRow:selectedRow forComponent:i];
        [cirlb setText:title];
        if ([title isEqualToString:@"工作日"]) {
            [UserData sharedUser].prohibit = 5;
        }
        else {
            [UserData sharedUser].prohibit = 7;
        }
    }

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{  
    if (pickerView == circuView) {
        return [self.type count];
    }
    else {
      
        if(component == kMiniteComponent)
        {   
            return [self.pickerSource count];
        }
        return [self.secondArr count]; 
    }
} 

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView  
{  
    if (pickerView == circuView) {
        return 1;
    }
    else {
        return 2;  
    }
   
}

-(IBAction)selectGender:(id)Sender{

    if (Sender==male) {
        [UserData sharedUser].gender = kMALE;
        selected.frame=CGRectMake(102, 22, 60, 50);
    }
    else {
        [UserData sharedUser].gender = kFEMALE;
        selected.frame=CGRectMake(184, 22, 60, 50);
    }
}

-(IBAction)updateCircu:(id)sender {
    
    if (state == unfocused) {
        self.pickerSource = self.type;
        [circuView reloadAllComponents];
        
        [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260 , 320, 260)];
        [self setAnimatedFrame:scrollView with:0.3 and:CGRectMake(0, -260 + 64, 320, [UIScreen mainScreen].bounds.size.height)];
        
        [self setValue:circuView withData:self.type withComponent:0 with:cirlb.text];
         [circuView setHidden:NO];
        state = onweek;
    }
}

-(IBAction)updateTime:(id)Sender {
    
    if (Sender == noti1Btn && state == unfocused) {
        state = onNoti1;
        self.pickerSource = self.morningArr;
        [picker reloadAllComponents];
        [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260 , 320, 260 ) ];
        [self setAnimatedFrame:scrollView with:0.3 and:CGRectMake(0, -260 + 64, 320, [UIScreen mainScreen].bounds.size.height ) ];
        /*
         setValue:(UIPickerView *)pickerView withData:(NSArray *)dataSource withComponent:(NSInteger)component with:(NSString *)value
        */
        [self setValue:picker withData:self.morningArr withComponent:kMiniteComponent with:n1lb1.text];
        [self setValue:picker withData:self.secondArr withComponent:kSecondComponent with:n1lb2.text];
        
        [circuView setHidden:YES];
    }
    else if(Sender == noti2Btn && state == unfocused){
        state = onNoti2;
        self.pickerSource = self.noonArr;
        [picker reloadAllComponents];
        [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 260 , 320, 260)];
        [self setAnimatedFrame:scrollView with:0.3 and:CGRectMake(0, -260 + 64, 320, [UIScreen mainScreen].bounds.size.height)];
        
        [self setValue:picker withData:self.noonArr withComponent:kMiniteComponent with:n2lb1.text];
        [self setValue:picker withData:self.secondArr withComponent:kSecondComponent with:n2lb2.text];
        [circuView setHidden:YES];
    }
    
}


-(void)slideSit{
    sitLbl.text = [NSString stringWithFormat:@"%d", (int)sitSlider.value];
}

-(void)slideComp{
    compLbl.text = [NSString stringWithFormat:@"%d", (int)compSlider.value];
}

-(void)cancel {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
}

-(void) setAnimatedFrame: (UIView *)view  with :(CGFloat) animateTime and: (CGRect)frame{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:animateTime];
    [view setFrame:frame];    
    [UIView commitAnimations];
}

-(IBAction)OKPressed:(id)sender {
    [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height  , 320, 260)];
    [self setAnimatedFrame:scrollView with:0.3 and:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    state = unfocused;
}

-(IBAction)cancelPressed:(id)sender {
    [self setAnimatedFrame:popUpView with:0.3 and:CGRectMake(0, [UIScreen mainScreen].bounds.size.height , 320, 260)];
    [self setAnimatedFrame:scrollView with:0.3 and:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    state = unfocused;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma AlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1) {
        [self statisitics];
        NSString * noti1Str = [NSString stringWithFormat:@"%@%@",n1lb1.text,n1lb2.text];
        NSString * noti2Str = [NSString stringWithFormat:@"%@%@",n2lb1.text,n2lb2.text];
        [UserData sharedUser].noti1Time = noti1Str;
        [UserData sharedUser].noti2Time = noti2Str;
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        if ([UserData sharedUser].prohibit == 7) {
            NSLog(@"PROHIBIT = 7");
            //[self makeNotification:n1lb1.text and:n1lb2.text andType:0];
            //[self makeNotification:n2lb1.text and:n2lb2.text andType:1];
        }
        else {
            NSLog(@"PROHIBIT = 5");
            //[self makeWeekNotification:n1lb1.text and:n1lb2.text andType:0];
            //[self makeWeekNotification:n2lb1.text and:n2lb2.text andType:1];
            
        }
        
        
        [UserData sharedUser].sittingTime = (int)sitSlider.value;
        [UserData sharedUser].compTime = (int)compSlider.value;
        
        [[UserData sharedUser] importUser];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        AssesViewController * vc = [self isContainedInWithClass:[AssesViewController class]];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"configFinished"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (vc != nil) {
            [appDelegate.preVC.navigationController popToViewController:(UIViewController *)vc animated:YES];
        }
        else {
            
            vc = [[AssesViewController alloc]initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)statisitics {
    int gender = [UserData sharedUser].gender;
    NSString * genderStr = (gender == 1)?@"男":@"女";
    
    NSString * sittingStr = [NSString stringWithFormat:@"%d",[UserData sharedUser].sittingTime];
    NSString * computerStr = [NSString stringWithFormat:@"%d",[UserData sharedUser].compTime];
    
    NSString * noti1Str = [NSString stringWithFormat:@"%@%@",n1lb1.text,n1lb2.text];
    NSString * noti2Str = [NSString stringWithFormat:@"%@%@",n2lb1.text,n2lb2.text];
    
    NSString * prohibitStr;
    if([UserData sharedUser].prohibit == 5 ){
        prohibitStr = @"五天制";
    }
    else
        prohibitStr = @"七天制";
    
    int PartsNum = 0;
    
    if ([UserData sharedUser].neck == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].shoulder == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].back == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].waist == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].wrist == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].head == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].finger == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].leg == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].elbow == 1) {
        PartsNum++;
    }
    if ([UserData sharedUser].butt == 1) {
        PartsNum++;
    }

    NSString * PartsNumStr = [NSString stringWithFormat:@"%d", PartsNum];
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          genderStr, @"gender",  sittingStr,@"SittingTime",computerStr,@"CompTime",noti1Str,@"Time1",noti2Str,@"Time2",prohibitStr,@"DaysPerWeek",PartsNumStr,@"PartsNum",nil];
    [MobClick event:@"UserStatus" attributes:dict];
}

@end
