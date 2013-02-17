//
//  NoticeViewController.m
//  TestUI
//
//  Created by Ye Ke on 1/9/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "QuizResultViewController.h"
#import "UserData.h"
#import "FTAnimation.h"
#import "FlipView.h"
#import "AnimationDelegate.h"
#import "VTracker.h"

@interface QuizResultViewController ()

@end

#define CELL_CONTENT_WIDTH 232.0f
#define CELL_CONTENT_MARGIN 5.0f

#define OK_x 164 + 55
#define other_x 39 + 55

@implementation QuizResultViewController
//@synthesize delegate;
@synthesize delegate;
@synthesize contentView;
@synthesize titleLbl;
@synthesize window;
@synthesize healthstatus;
@synthesize partlbl;
@synthesize partsName;
@synthesize partlbltitle;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom Initialization
        partsName =[NSArray arrayWithObjects:@"头部",@"颈部",@"肩部",@"手部",@"背部",@"腰部",@"臀部",@"腿部", nil];
        [partsName retain];
    }
    return self;
}

-(void)dealloc {
    NSLog(@"QuizResultView DEALLOC");
    [super dealloc];
}

-(void)setContent:(NSString *)str {
    NSLog(@"the fit rate is %f",[UserData sharedUser].fitRate);
    if ([UserData sharedUser].fitRate<45) {
        healthstatus.text=[NSString stringWithFormat:@"急需锻炼"];
    }
    else if([UserData sharedUser].fitRate>=45&&[UserData sharedUser].fitRate<60){
            healthstatus.text=[NSString stringWithFormat:@"缺乏锻炼"];
    }
    else if([UserData sharedUser].fitRate>=60&&[UserData sharedUser].fitRate<80){
                healthstatus.text=[NSString stringWithFormat:@"亚健康"];
    }
    else{
            healthstatus.text=[NSString stringWithFormat:@"健康"];
    }
    
   partlbl.text=@"";
    
    int i =0;
    int j=0;
    
    for(Part* pt in [UserData sharedUser].parts)
    {
        
        if( pt.status == BAD||pt.status == MEDIUM)
        {
            j++;
            if (i==0) {
                partlbl.text=[NSString stringWithFormat:@"%@%@",partlbl.text, [partsName objectAtIndex:i]];
            }
            else{
            partlbl.text=[NSString stringWithFormat:@"%@ %@",partlbl.text, [partsName objectAtIndex:i]];
            }
            
        }
        
        i++;
    }
    
    if (j==0) {
        partlbltitle.text=@"你的身体基本健康，但记得要保持锻炼。";
    }
    
    content  = str;
}

-(void)setTitle:(NSString *)ttitle {
    title = ttitle;
}

-(void)viewDidAppear:(BOOL)animated {
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    self.contentView.text = content;
    //self.contentView.frame = CGRectMake(0, 0, 260, size.height + 40);
    self.contentView.scrollEnabled = YES;
    self.contentView.contentSize = size;
  //  self.contentView.center = CGPointMake(self.view.frame.size.width/2.0-10,self.view.frame.size.height/2.0+85);
    [self performSelector:@selector(delayflip) withObject:nil afterDelay:0.8];

   // [self adjustView];
}

-(void)delayflip{
    
 [self showFlipView:[UserData sharedUser].fitRate];
    
}

-(void)moveDownorUp:(UIView *)view for:(int)height {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + height, view.frame.size.width, view.frame.size.height);
}

-(void)show {
    
    [window popIn:.8 delegate:nil];
    
}

-(void)hidden {
  //  [shade setHidden:YES];
  //  [window setHidden:YES];
 //   [window popOut:.2 delegate:nil];
}

-(void)disappear {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        [self moveDownorUp:self.view for:30];
    }completion:^(BOOL finished){
        self.view.hidden = YES;
    }];
    [UIView commitAnimations];
}

-(IBAction)OKPressed:(id)sender {
    
    [[VTracker tracker] packageDailyInfo];
    [[VTracker tracker] sendOutData];
    
    [self disappear];
    [delegate OKDidPressed];
}

-(IBAction)otherPressed:(id)sender {
    [self disappear];
    [delegate otherDidPressed];
}



-(void)showFlipView:(float) rate{
    AnimationDelegate *animationDelegate;
    AnimationDelegate *animationDelegate2;
     AnimationDelegate *animationDelegate3;
    //==========================
    
    animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                          directionType:kDirectionForward];
    animationDelegate.controller = self;
    animationDelegate.perspectiveDepth = 200;
    animationDelegate.nextDuration=0.25;
    animationDelegate.repeatDelay = 0.00;
    animationDelegate.sensitivity = 100;
    animationDelegate.gravity = 2;
    
    
    animationDelegate2 = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                           directionType:kDirectionForward];
    animationDelegate2.controller = self;
    animationDelegate2.perspectiveDepth = 200;
    animationDelegate2.nextDuration=0.35;
    animationDelegate2.repeatDelay = 0.00;
    animationDelegate2.sensitivity = 100;
    animationDelegate2.gravity = 2;
    
    
    animationDelegate3 = [[AnimationDelegate alloc] initWithSequenceType:kSequenceAuto
                                                          directionType:kDirectionForward];
    animationDelegate3.controller = self;
    animationDelegate3.perspectiveDepth = 200;
    animationDelegate3.nextDuration=0.2;
    animationDelegate3.repeatDelay = 0.00;
    animationDelegate3.sensitivity = 100;
    animationDelegate3.gravity = 2;
    
    int temp1=0;
    if ([UIScreen mainScreen].bounds.size.height>=568) {
        temp1=45+40;
    }
    else{
        temp1=45;
    }
    FlipView *flipView4;
    flipView4 = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                  frame:CGRectMake(237,temp1, 10, 36)];
    
    FlipView *flipView3;
    flipView3 = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                  frame:CGRectMake(247,temp1, 23, 36)];
    
    FlipView *flipView;
    flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                 frame:CGRectMake(215, temp1, 23, 36)];
    FlipView *flipView2;
    flipView2 = [[FlipView alloc] initWithAnimationType:kAnimationFlipVertical
                                                  frame:CGRectMake(192,temp1, 23, 36)];
    
    animationDelegate.transformView = flipView;
    animationDelegate2.transformView = flipView2;
     animationDelegate3.transformView = flipView3;
    [self.view addSubview:flipView];
    [self.view addSubview:flipView2];
    [self.view addSubview:flipView3];
    [self.view addSubview:flipView4];
    flipView.fontSize = 30;
    flipView2.fontSize = 30;
    flipView3.fontSize = 30;
    flipView4.fontSize = 30;
    flipView.font = @"HelveticaNeue-Bold";
    flipView.fontAlignment = @"center";
    flipView.textOffset = CGPointMake(0.0, 0.0);
    flipView.textTruncationMode = kCATruncationEnd;
    
    flipView2.font = @"HelveticaNeue-Bold";
    flipView2.fontAlignment = @"center";
    flipView2.textOffset = CGPointMake(0.0, 0.0);
    flipView2.textTruncationMode = kCATruncationEnd;
    
    flipView3.font = @"HelveticaNeue-Bold";
    flipView3.fontAlignment = @"center";
    flipView3.textOffset = CGPointMake(0.0, 0.0);
    flipView3.textTruncationMode = kCATruncationEnd;
    
    flipView4.font = @"HelveticaNeue-Bold";
    flipView4.fontAlignment = @"center";
    flipView4.textOffset = CGPointMake(0.0, 0.0);
    flipView4.textTruncationMode = kCATruncationEnd;
    int ten=rate/10;
    int single=rate-ten*10;
    int temp=rate*10;
    int point=temp-single*10-ten*100;
    NSLog(@"%d %d %d",ten,single,point);
    for (int i=0; i<10; i++) {
        
        [flipView printText:[NSString stringWithFormat:@"%d",(9-i)%10] usingImage:nil backgroundColor:[UIColor colorWithRed:0.221f green:0.221f blue:0.221f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];
        
        [flipView2 printText:[NSString stringWithFormat:@"%d",(9-i)%10] usingImage:nil backgroundColor:[UIColor colorWithRed:0.221f green:0.221f blue:0.221f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];
        
         [flipView3 printText:[NSString stringWithFormat:@"%d",(9-i)%10] usingImage:nil backgroundColor:[UIColor colorWithRed:0.221f green:0.221f blue:0.221f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];
    }
    
    [flipView4 printText:[NSString stringWithFormat:@"."] usingImage:nil backgroundColor:[UIColor colorWithRed:0.221f green:0.221f blue:0.221f alpha:1] textColor:[UIColor colorWithRed:0.58f green:0.964f blue:0.061f alpha:1]];

    //===========================
    


    if (single!=0) {
        [animationDelegate startAnimation:kDirectionNone];
        [self performSelector:@selector(stopflip:) withObject:animationDelegate afterDelay:0.25*single];
       
    }

    if (ten!=0) {
        [animationDelegate2 startAnimation:kDirectionNone];
        [self performSelector:@selector(stopflip:) withObject:animationDelegate2 afterDelay:0.35*ten];
       
    }
    
    if (point!=0) {
        [animationDelegate3 startAnimation:kDirectionNone];
        [self performSelector:@selector(stopflip:) withObject:animationDelegate3 afterDelay:0.2*point];
        
    }
        [flipView release];
     [flipView2 release];
}



-(void)stopflip: (AnimationDelegate *)animation{
    animation.repeat=NO;
}





@end
