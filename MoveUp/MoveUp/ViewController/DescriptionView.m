//
//  DescriptionView.m
//  TestUI
//
//  Created by FreeXue on 13-2-2.
//  Copyright (c) 2013年 New Success. All rights reserved.
//
#define bg_width 140
#define bg_height 80
#import "DescriptionView.h"
#import "FTAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "UserData.h"
#import "Part.h"
@implementation DescriptionView
@synthesize parts;
@synthesize healthStatus;
@synthesize averageTimes;
@synthesize background;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, bg_width, bg_height)];
    if (self) {
        // Initialization code

        background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bg_width, bg_height)];
        [background setImage:[UIImage imageNamed:@"partsTips_bottom.png"]];
        [self addSubview:background];

        parts=[[UILabel alloc]initWithFrame:CGRectMake(5, 10, bg_width, 20)];
        averageTimes=[[UILabel alloc]initWithFrame:CGRectMake(5, 30, bg_width, 20)];
        healthStatus=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, bg_width, 20)];
        [parts setBackgroundColor:[UIColor clearColor]];
        [averageTimes setBackgroundColor:[UIColor clearColor]];
        [healthStatus setBackgroundColor:[UIColor clearColor]];
        
        [parts setFont:[UIFont fontWithName:@"Arial" size:12]];
        [averageTimes setFont:[UIFont fontWithName:@"Arial" size:12]];
        [healthStatus setFont:[UIFont fontWithName:@"Arial" size:12]];
        parts.text=@"部位";
        averageTimes.text=@"累计运动";
        healthStatus.text=@"状态";
        [self addSubview:parts];
        [self addSubview:averageTimes];
        [self addSubview:healthStatus];
        [self setHidden:YES];
    }
    return self;
}

-(void)setPos:(UIButton *)click{
    
      [self setCenter:CGPointMake(click.frame.origin.x+click.frame.size.width/2, click.frame.origin.y-18)];
    [self fadeIn:0.3 delegate:nil];
    int ten=click.tag/10;
    int single=click.tag-ten*10;
    NSLog(@"ten is %d single is %d",ten,single);
    NSArray *  partsName =[NSArray arrayWithObjects:@"头部",@"颈部",@"肩部",@"手部",@"背部",@"腰部",@"臀部",@"腿部", nil];
    parts.text=[NSString stringWithFormat:@"部位: %@", [partsName objectAtIndex:(ten-1)]];
    Part *part=[[UserData sharedUser].parts objectAtIndex:(ten-1)];
    NSString *status;
    switch (part.status) {
        case 0:
            status=@"保持锻炼";
            break;
        case 1:
            status=@"加强锻炼";
            break;
        case 2:
            status=@"缺乏锻炼";
            break;
        case 3:
            status=@"急需锻炼";
            break;
        default:
            break;
    }
    averageTimes.text=[NSString stringWithFormat:@"累计运动: %d 次", part.exercisedNum];
    healthStatus.text=[NSString stringWithFormat:@"状态: %@ ", status];
    switch (single) {
        case 1:{
            [background setImage:[UIImage imageNamed:@"partsTips_top.png"]];
               [self setCenter:CGPointMake(click.frame.origin.x+click.frame.size.width/2, click.frame.origin.y+1.5*click.frame.size.height)];
            break;
        }
        case 2:{
            [background setImage:[UIImage imageNamed:@"partsTips_bottom.png"]];
          
            break;
        }
        case 3:{
            [background setImage:[UIImage imageNamed:@"partsTips_left.png"]];
             [self setCenter:CGPointMake(click.frame.origin.x+bg_width/2.2, click.frame.origin.y-click.frame.size.height/1.9)];
            break;
        }
        case 4:{
            [background setImage:[UIImage imageNamed:@"partsTips_bottom.png"]];
            
            break;
        }

        default:
            break;
    }
}

-(void)Disappear{
  [self fadeOut:0.15 delegate:nil];
}

-(id)init{
    
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(0, 0, bg_width, bg_height)];
        background=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bg_width, bg_height)];
        [background setImage:[UIImage imageNamed:@"partsTips_bottom.png"]];
       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
