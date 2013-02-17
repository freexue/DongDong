//
//  CrusierView.m
//  TestUI
//
//  Created by Ye Ke on 1/15/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "CrusierView.h"
#define kMaxHeight 360
#define kMinHeight 0
#define kOffsetX 29
#define kOffsetY -5

@implementation CrusierView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        ori_percent = 0;
        
        
        //Copy
        copy_bg = [[UIImageView alloc]init];
        copy_bg.image = [UIImage imageNamed:@"point.png"];
        
        copy_cru = [[UILabel alloc]init];
        copy_cru.backgroundColor = [UIColor clearColor];
        
        [self addSubview:copy_bg];
        [self addSubview:copy_cru];
        
        bgView = [[UIImageView alloc]init];
        crusier = [[UILabel alloc]init];
        self.backgroundColor = [UIColor clearColor];
        bgView.image = [UIImage imageNamed:@"point.png"];
        crusier.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:bgView];
        [self addSubview:crusier];
        
        bgView.frame = CGRectMake(-10, 360, 59, 20);
        crusier.frame = CGRectMake(19, 362, 45, 20);
        
        copy_bg.frame = CGRectMake(-10, 360, 59, 20);
        copy_cru.frame = CGRectMake(19, 362, 45, 20);
        
        crusier.font = [UIFont fontWithName:@"Arial" size:10];
        copy_cru.font = [UIFont fontWithName:@"Arial" size:10];
    }
    return self;
}


-(float)oriPercent {
    return ori_percent;
}

-(void)setOriPercent:(float)pc {
    ori_percent = pc;
    copy_cru.text = [NSString stringWithFormat:@"%.1f",pc * 100];
}

-(void)moveTo:(double)percent withShadowLeft:(BOOL)yes {
    int diff = (kMaxHeight - kMinHeight);
    int height = diff * (1 - percent) + kMinHeight;

    int copy_height = diff * (1 - ori_percent) + kMinHeight;
    
    bgView.frame = CGRectMake(-10, height * 0.985, 59, 20);
    crusier.frame = CGRectMake(20, height * 0.985, 45, 20);
    
    crusier.text = [NSString stringWithFormat:@"%.1f",percent * 100];
    
    //NSLog(@"percent %f", percent);
    
    if (!yes) {
        copy_bg.hidden = YES;
        copy_cru.hidden = YES;
    }
    else {
        copy_bg.hidden = NO;
        copy_cru.hidden = NO;
        
        copy_bg.frame = CGRectMake(-10, copy_height, 59, 20);
        copy_cru.frame = CGRectMake(19, copy_height + 1, 45, 20);
    }
}

-(void)setCopyAlpha:(float)alpha {
    copy_bg.alpha = alpha;
    copy_cru.alpha = alpha;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}

@end
