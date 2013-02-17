//
//  TriggerView.m
//  TestUI
//
//  Created by Ke Ye on 8/10/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "TriggerView.h"
#import "ReadingFile.h"
#define ACTION_NUM 4

@implementation TriggerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)InitOrder:(NSMutableArray *)arr {
    currentNum = 0;
    orders = arr;
    btns = [[NSMutableArray alloc]init];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"DrawRect");
//    for (int i =0; i<ACTION_NUM; i++) {
//        
//        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(i*54+9, 9, 46, 46)];
//      //  NSLog(@"the order count %d",orders.count);
//        ReadingFile * rf = [orders objectAtIndex:i];
//        NSString * imgName = [NSString stringWithFormat:@"7%@@2x.png", rf.category];
//        NSLog(@"name %@", imgName);
//        
//        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//        button.userInteractionEnabled = NO;
//        button.alpha=0.3;
//        [self addSubview:button];
//        [btns addObject:button];
//    }
//        UIButton * currentBtn = [btns objectAtIndex:currentNum];
//        currentBtn.alpha=1;
}

-(void)setSwitchViewBtn:(UIButton *)btn {
//    btn.frame = CGRectMake(200, 10, btn.frame.size.width, btn.frame.size.height);
//    [self addSubview:btn];
}

-(void)GoNextPanel {
//    UIButton * currentBtn = [btns objectAtIndex:currentNum];
//   
//    ReadingFile * rf = [orders objectAtIndex:currentNum];
//NSString * imgName = [NSString stringWithFormat:@"7%@_check@2x.png", rf.category];
//    NSLog(@"name %@", imgName);
//    
//    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(currentNum*54+9, 9, 46, 46)];
//    [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//    button.userInteractionEnabled = NO;
//    button.alpha = 0;
//    [self addSubview:button];
//    
//    [UIView animateWithDuration:2.5
//                     animations:^{
//                         button.alpha = 0.3;
//                         currentBtn.alpha = 0;
//                         
//                         if (currentNum != 3) {
//                             UIButton * nextBtn = [btns objectAtIndex:currentNum+1]; 
//                             nextBtn.alpha = 1;
//                         }
//                     } 
//                     completion:^(BOOL finished){
//                         [btns replaceObjectAtIndex:currentNum withObject:button];
//                         [currentBtn removeFromSuperview];
//                         if (currentNum != 4) 
//                         currentNum ++ ;
//                     }];
}

@end
