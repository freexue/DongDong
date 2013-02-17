//
//  DetailViewController.m
//  TestUI
//
//  Created by FreeXue on 13-1-3.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "AssesViewController.h"
#import "NotificationSettingViewController.h"
#import "VTracker.h"
#import "UserData.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize listData;
@synthesize detailData;
@synthesize _tableView;
@synthesize scrollview;
@synthesize infoData;
@synthesize finishquiz;
@synthesize result;
@synthesize sex;
@synthesize ageField;
@synthesize canedit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom Initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
}

- (void)viewDidLoad
{
    
     [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [[VTracker tracker] recountViewTime];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
        [[UserData sharedUser] resetUser];
        [[UserData sharedUser] importUser];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"configFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"excerciseFinished"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"InNotification"];
    }
    [scrollview setContentOffset:CGPointMake(0, 0) animated:NO];
    self.listData =[[NSArray alloc] initWithObjects:@"性别",@"年龄",nil];
    infoData = [[NSMutableArray alloc] initWithObjects:self.listData, nil];
    _tableView.backgroundColor=[UIColor clearColor];
    scrollview.contentSize=CGSizeMake(320, 1700);
    
    ageField.delegate = self;
    if ([UserData sharedUser].age == 0) {
        ageField.text = @"填写";
    }
    else
        ageField.text = [NSString stringWithFormat:@"%d", [UserData sharedUser].age];
    ageField.font = [UIFont fontWithName:@"System Bold" size:16];
    ageField.textColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ageFieldDidFinish) name:@"AgeFiledDone" object:nil];
    
    sex = [[UISegmentedControl alloc] initWithFrame:CGRectMake(172, 63, 130, 40)];
    [sex insertSegmentWithTitle:@"男" atIndex:0 animated:YES];
    [sex insertSegmentWithTitle:@"女" atIndex:1 animated:YES];
    sex.momentary=NO;
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]) {
        sex.selected=NO;
        [canedit setHidden:NO];
        
    }
    else{
        NSLog(@"[UserData sharedUser].gender %d", [UserData sharedUser].gender);
        [sex setSelectedSegmentIndex:1 - [UserData sharedUser].gender];
        [canedit setHidden:YES];
        
    }
    [sex addTarget:self action:@selector(switchtonext:)forControlEvents:UIControlEventValueChanged];
    [scrollview addSubview:sex];
    scrollview.delegate = self;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]) {
        [canedit setHidden:YES];
        [canedit removeFromSuperview];
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 45, 30)];
        [menuButton setBackgroundImage:[UIImage imageNamed:@"0button_nav.png"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(showMenu)forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *menuBarItem =[[UIBarButtonItem alloc] initWithCustomView:menuButton];
        self.navigationItem.leftBarButtonItem = menuBarItem;
        
    }
    else{
        
        self.navigationItem.hidesBackButton=YES;
    }
    self.navigationItem.title=@"编辑资料";
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * questions = [dictionary objectForKey:@"Questions"];
    
    UILabel *response=[[UILabel alloc]initWithFrame:CGRectMake(20, 1500, 280 , 150)];
    response.backgroundColor=[UIColor clearColor];
    
    response.text=@"                       免责声明 \n\n       本程序不适合手腕，颈椎和腰椎等骨骼受过外伤或者有相关骨骼疾病的患者，程序中的动作和方法仅作为日常生活的保健建议，如有身体不适请停止练习并向医生咨询。";
    response.textColor = [UIColor blackColor];
    response.font = [UIFont fontWithName:@"System Bold" size:16];
    
    [response setNumberOfLines:0];
    response.lineBreakMode = UILineBreakModeWordWrap;
    response.textAlignment = UITextAlignmentLeft;
    
    [scrollview addSubview:response];
    finishquiz= [[UIButton alloc] initWithFrame:CGRectMake(110, 1430, 100 , 46)];
    [finishquiz setBackgroundImage:[UIImage imageNamed:@"0button_long@2x.png"] forState:UIControlStateNormal];
    [finishquiz setBackgroundImage:[UIImage imageNamed:@"0button_long_down@2x.png"] forState:UIControlStateHighlighted];
    [finishquiz setTitle:@"查看结果" forState:UIControlStateNormal];
    [finishquiz setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    finishquiz.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [finishquiz addTarget:self action:@selector(finish)forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:finishquiz];
    //===========问卷lay out
    for (int i=0; i<[questions count]; i++) {
        UIImageView *divbg=[[UIImageView alloc]initWithFrame:CGRectMake(9, 138+120*(i+1), 300, 45)];
        divbg.image=[UIImage imageNamed:@"2choice_bg@2x.png"];
        divbg.tag=100+i;
        [scrollview addSubview:divbg];
   
        UIImageView *div;
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
                 div=[[UIImageView alloc]initWithFrame:CGRectMake(0, 190+70*(i+1), 320, 2)];
        }
        else
        {
             div=[[UIImageView alloc]initWithFrame:CGRectMake(0, 190+120*(i+1), 320, 2)];
        }
        div.image=[UIImage imageNamed:@"0divider@2x.png"];
        div.tag=200+i;
        [scrollview addSubview:div];
        NSDictionary *item=[questions objectAtIndex:i];
        NSString * question = [item objectForKey:@"Question"];
        UILabel * q;
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
           q=[[UILabel alloc]initWithFrame:CGRectMake(20, 165+70*i, 280, 120)];
        }
        else{
            q=[[UILabel alloc]initWithFrame:CGRectMake(20, 165+120*i, 280, 120)];
        }
        q.tag = i + 1;
        
        q.backgroundColor=[UIColor clearColor];
        if (i==questions.count-1 && [UserData sharedUser]) {
            q.text=@"在日常工作中，您会因久坐或翘二郎腿而感到腿部疼痛吗？";
        }
        else{
            q.text=question;
        }
        
        q.lineBreakMode = UILineBreakModeWordWrap;
        q.numberOfLines = 0;
        
        q.textColor = [UIColor grayColor];

        [q setFont:[UIFont fontWithName:@"Arial" size:15]];
        
        
        [scrollview addSubview:q];
        for (int j=0; j<4; j++) {
            UIButton *choose1 = [[UIButton alloc] initWithFrame:CGRectMake(16+72*j, 262+120*i, 70, 37)];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
                choose1.hidden=YES;
                divbg.hidden=YES;
                finishquiz.hidden=YES;
            }
            [choose1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [choose1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            if ([[[UserData sharedUser].quizData objectAtIndex:i]intValue ]==j+1) {
                [choose1 setBackgroundImage:[UIImage imageNamed:@"2choice_selected.png"] forState:UIControlStateNormal];
                [choose1 setBackgroundImage:[UIImage imageNamed:@"2choice_down.png"] forState:UIControlStateHighlighted];
                [choose1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            else{
                [choose1 setBackgroundImage:[UIImage imageNamed:@"2choice.png"] forState:UIControlStateNormal];
                [choose1 setBackgroundImage:[UIImage imageNamed:@"2choice_down.png"] forState:UIControlStateHighlighted];
                
            }
            choose1.tag=10*(i)+j+1;

            choose1.titleLabel.font = [UIFont systemFontOfSize: 14.0];
            switch (j) {
                case 0:
                    [choose1 setTitle:@"几乎没有" forState:UIControlStateNormal];
                    break;
                case 1:
                    [choose1 setTitle:@"偶尔" forState:UIControlStateNormal];
                    break;
                case 2:
                    [choose1 setTitle:@"经常" forState:UIControlStateNormal];
                    break;
                case 3:
                    [choose1 setTitle:@"非常频繁" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            [choose1 addTarget:self action:@selector(makeChoose:)forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:choose1];
            
        }
    }
}


-(void)updateFrame:(int)index{
    if (index<10) {
        
    
    if ([[[UserData sharedUser].quizData objectAtIndex:index]intValue]==0) {
        
    
    for(UIView * view in scrollview.subviews) {
        if ([view isKindOfClass:[UIImageView class]]&&view.tag/100==2) {
            UIImageView *thisdiv=(UIImageView*)view;
            if (thisdiv.tag==200+index) {
                [thisdiv setFrame:CGRectMake(0, 190+120*(index+1), 320, 2)];
            }
            
            else if(thisdiv.tag>200+index){
                NSLog(@"this div is %f",thisdiv.frame.origin.y);
                [thisdiv setFrame:CGRectMake(0, 240+70*(thisdiv.tag-200)+50*index, 320, 2)];
            }
        }
        
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *quiz=(UILabel*)view;
            if (quiz.tag==index+1) {
                 [quiz setTextColor:[UIColor blackColor]];
                //   [quiz setFrame:CGRectMake(20, 160+120*(index+1),  280, 120)];
            }
            
            else if(quiz.tag>index+1){
               
                 [quiz setFrame:CGRectMake(20, 145+70*(quiz.tag)+50*index,  280, 120)];
            }
        }
        
    }
    }
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
    [[VTracker tracker] registerLT:@"DETAIL"];
}

-(void)switchtonext: (UIView *)view{

    [ageField resignFirstResponder];
    NSLog(@"find it");
    if (sex.selectedSegmentIndex==0) {
        [UserData sharedUser].gender =kMALE;
        
        [self._tableView reloadData];
    }
    else
    {
        [UserData sharedUser].gender = kFEMALE;
        //[infoData replaceObjectAtIndex:infoData.count - 1 withObject:@"在日常工作中，您会因穿高跟鞋而感到腿部疼痛吗？"];
        [self._tableView reloadData];
    }
    
    for(UIView * view in scrollview.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            if(view.tag == 10)
            {
                UILabel * lbl = (UILabel *)view;
                if ([UserData sharedUser].gender == kMALE) {
                lbl.text = @"在日常工作中，您会因久坐或翘二郎腿而感到腿部疼痛吗？";
                }else {
                  lbl.text = @"在日常工作中，您会因穿高跟鞋而感到腿部疼痛吗？";
                }
            }
        }
    }
    
    for (UIView * view in scrollview.subviews) {
        if ([view isKindOfClass:[UISegmentedControl class]]) {
          
            [ageField setHidden:NO];
          [scrollview setContentOffset:CGPointMake(0, 50) animated:YES]; 
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]) {
                [canedit setHidden:YES];
                [canedit removeFromSuperview];
              [self performSelector:@selector(openpicker) withObject:nil afterDelay:0.3];
            }
    
            
        }
    }
}

-(void)openpicker{
    [ageField becomeFirstResponder];
}

-(void)finish {
    
    notiViewController = [[NoticeViewController alloc] initWithNibName:XIBNameFor(@"NoticeViewController") bundle:nil];
  
    quizresultViewController = [[QuizResultViewController alloc] initWithNibName:XIBNameFor(@"QuizResultViewController") bundle:nil];
    
    notiViewController.delegate = self;
    quizresultViewController.delegate = self;
    
  
    
    if ([ageField.text isEqualToString:@"填写"] ) {
        
        [[VTracker tracker] registerGR:@"NOTIME"];
        
        [self.view addSubview:notiViewController.view];
        [notiViewController setType:kSimpleType];
        [notiViewController setTitle:@"信息缺失"];
        [notiViewController setContent:@"为了针对您的个人情况编排做操，请选择您的年龄"];
        [notiViewController show];
    }
    else if(sex.selectedSegmentIndex == -1) {
        
        [[VTracker tracker] registerGR:@"NOGENDER"];
        
          [self.view addSubview:notiViewController.view];
        [notiViewController setType:kSimpleType];
        [notiViewController setTitle:@"信息缺失"];
        [notiViewController setContent:@"为了针对您的个人情况编排做操，请选择您的性别"];
        [notiViewController show];
    }else {
        
        [[VTracker tracker] registerGR:@"DETAILOK"];
        
          [self.view addSubview:quizresultViewController.view];
        [Sympthon setAllPartsandSympthons:[UserData sharedUser].quizData];
        [quizresultViewController setTitle:@"诊断报告"];
        [quizresultViewController setContent:[self writeReport]];
        [quizresultViewController show];
       
    }
}

-(NSString *)writeReport {
    
    NSString * content = @"我们为您量身打造了最适合您的健身运动，建议您一天运动2到4次，对于改善身体状况和提高工作效率将起到非常积极的作用！";
    return content;
}

-(void)moveDownorUp:(UIView *)view for:(int)height {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + height, view.frame.size.width, view.frame.size.height);
}

-(void)fadeInViewAnimation:(UIView *)view {
    
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeChoose: (UIButton *)button{
    
    
    int tagnum=button.tag/10;
    int tagnumg=button.tag-10*tagnum;
    int tagvnumn=button.tag/10+1;
    NSLog(@"the index is now %d",tagnum);
     [self updateFrame:(tagnum+1)];
    [scrollview setContentOffset:CGPointMake(0, 125+120*tagvnumn) animated:YES];
    [detailData replaceObjectAtIndex:tagnum withObject:[NSNumber numberWithInt:tagnumg]];
    [[UserData sharedUser].quizData replaceObjectAtIndex:tagnum withObject:[NSNumber numberWithInt:tagnumg]];
    for (UIView * view in scrollview.subviews) { 
        if ([view isKindOfClass:[UIButton class]]&&view.tag/10==tagvnumn) {
            view.hidden=NO;
        }
        else if ([view isKindOfClass:[UIImageView class]]&&view.tag-100==tagvnumn) {
            view.hidden=NO;
        }
        
        if ([view isKindOfClass:[UIButton class]]&&view.tag/10==tagnum) {
          //  NSLog(@"%d", view.tag);
            UIButton *temp= (UIButton *)view;
            [temp setBackgroundImage:[UIImage imageNamed:@"2choice.png"] forState:UIControlStateNormal];
                [temp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
        }
    }
     [button setBackgroundImage:[UIImage imageNamed:@"2choice_selected.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    int flag=0;
    for (int i=0; i<10; i++) {
        if ([[[UserData sharedUser].quizData objectAtIndex:i]intValue]==0) {
            flag++;
            break;
        }
    }
    if (flag!=0) {
        finishquiz.hidden=YES;
    }
    else{
        finishquiz.hidden=NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==1&&sex.selectedSegmentIndex!=-1) {
        [ ageField becomeFirstResponder];
        
        //===========================================================================
           }
    else{
        [ageField resignFirstResponder];
    }

}

-(NSInteger ) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger )section{
    return [[infoData objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [infoData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier]; 
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (cell==nil ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:showUserInfoCellIdentifier]
                autorelease];
    }
    [[cell textLabel] setText:[[infoData objectAtIndex:indexPath.section] objectAtIndex: indexPath.row]];
    [cell textLabel].font = [UIFont fontWithName:@"System Bold" size:14];
    [cell textLabel].textColor = [UIColor blackColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)showMenu {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate cancel];
    [ageField resignFirstResponder];
}

-(IBAction)goSetting:(id)sender{
     if (![[NSUserDefaults standardUserDefaults] boolForKey:@"configFinished"]){
         NotificationSettingViewController * settingVC;
         settingVC = [[NotificationSettingViewController alloc]initWithNibName:XIBNameFor(@"NotificationSettingViewController") bundle:nil];
         [self.navigationController pushViewController:settingVC animated:NO];
         
         CATransition *animation = [CATransition animation];
         [animation setDuration:1.05];
         [animation setType:@"pageCurl"]; //pageCurl
         [animation setSubtype:kCATransitionFromRight];
         [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
         
         
         [self.navigationController.view.layer addAnimation:animation forKey:nil];

     }
     else{
     
         AssesViewController * VC;
         VC = [[AssesViewController alloc]initWithNibName:XIBNameFor(@"AssesViewController") bundle:nil];
         [self performSelector:@selector(switchToNextPage:) withObject:VC afterDelay:0.0];
     }
}


-(void)switchToNextPage:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark NoticeViewDelegate

-(void)OKDidPressed {
    
    [notiViewController disappear];
    [self goSetting:nil];
}

-(void)otherDidPressed {
    if (sex.selected == NO) {
        
    }
    else {
        if ([ageField.text isEqualToString:@"填写"] || [ageField.text isEqualToString:@""] || [[ageField text] length ]== 0) {
            [ageField becomeFirstResponder];
        }
    }
}


-(IBAction)canedit:(id)sender{
    NSLog(@"show click");
    if (sex.selected) {
        
    }
    else{
        notiViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        notiViewController.delegate = self;
        [self.view addSubview:notiViewController.view];
        [notiViewController setType:kSimpleType];
        [notiViewController setTitle:@"信息缺失"];
        [notiViewController setContent:@"为了针对您的个人情况编排做操，请选择您的性别"];
        [notiViewController show];
    }


}
#pragma mark TextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

        textField.text = @"";
 
}

#pragma mark NumberPad Methods 
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    
    NSLog(@"Come Into HandleKeyBoardWillHide");
    ageField.delegate = self;
    
    if ([ageField.text isEqualToString:@"0"] || [ageField.text isEqualToString:@""] || [[ageField text] length ]== 0) {
        
        notiViewController = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
        notiViewController.delegate = self;
       
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.window addSubview:notiViewController.view];
        ageField.text = @"填写";
        [notiViewController setTitle:@"信息缺失"];
        [notiViewController setContent:@"为了针对您的个人情况编排做操，请选择您的年龄"];
        [notiViewController show];
        
    }
    else {
        for (UIView * view in scrollview.subviews) {
            if ([view isKindOfClass:[UIButton class]]&&view.tag/10==0) {
                view.hidden=NO;
            }
            else if ([view isKindOfClass:[UIImageView class]]&&view.tag-100==0) {
                view.hidden=NO;
            }
        }
    }
    
    [UserData sharedUser].age = [ageField.text intValue];
    
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
    }
    
}

- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    normalKeyboardHeight = kbSize.height;
    
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        if ([UIScreen mainScreen].bounds.size.height>=568) {
            doneInKeyboardButton.frame = CGRectMake(0, 480 +35, 106, 53);
        }
        else
        {
            doneInKeyboardButton.frame = CGRectMake(0, 480 - 53, 106, 53);
        }
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
        [doneInKeyboardButton setImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateHighlighted];
        [doneInKeyboardButton addTarget:self action:@selector(doneWithKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
    }
}

-(void)doneWithKeyboard {
    
    [ageField resignFirstResponder];
    [self updateFrame:0];
      [scrollview setContentOffset:CGPointMake(0, 160) animated:YES];
    if ([ageField.text isEqualToString:@"0"] || [ageField.text isEqualToString:@""] || [[ageField text] length ]== 0) {
        
  
        
    }
}

-(IBAction)hideKeyboard:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [ageField resignFirstResponder];
}

@end
