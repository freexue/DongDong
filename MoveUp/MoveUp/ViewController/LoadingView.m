//
//  LoadingView.m
//  TestUI
//
//  Created by FreeXue on 13-1-16.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import "LoadingView.h"
#import "SystemConfig.h"
#import <QuartzCore/QuartzCore.h>
#define loading_radius 30
#define img_width 320
#define img_height 417

#define img_height_568h 505

@implementation LoadingView

@synthesize loadinImg;
@synthesize blankFill;
@synthesize greenFill;
@synthesize figureImg;
@synthesize movedown;
-(void)dealloc {
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        
        
        
        //[loading setHidden:YES];
        self.movedown=0;
        if ([SystemConfig isIphone5]) {
            self.movedown=50.0;
            self.loadinImg=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img_width, img_height_568h)] autorelease];
            [self.loadinImg setImage:[UIImage imageNamed:@"wait1-568h.png"]];
        }
        else{
            self.loadinImg=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img_width, img_height)] autorelease];
            [self.loadinImg setImage:[UIImage imageNamed:@"wait1.png"]];
        }
        
        self.figureImg = [[[UIImageView alloc] initWithFrame:kFrame(CGPointMake(160, 177+movedown))] autorelease];
        self.figureImg.image = [UIImage imageNamed:@"7waitlabel.png"];
        
        self.greenFill = [[[UIView alloc] initWithFrame:kInnerFrame(CGPointMake(160, 177+movedown))] autorelease];
        self.greenFill.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:248.0/255.0 blue:40.0f/255.0 alpha:1.0];
        
        self.blankFill = [[[UIView alloc] initWithFrame:kInnerFrame(CGPointMake(160, 177+movedown))] autorelease];
        self.blankFill.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.loadinImg];
        [self addSubview:self.blankFill];
        [self addSubview:self.greenFill];
        [self addSubview:self.figureImg];
        
        self.greenFill.frame = kHideFrame(CGPointMake(160, 177+movedown));
        self.hidden = YES;
       
    }
    return self;
}

-(void)setSecondImage{
    if ([SystemConfig isIphone5]) {
        [self.loadinImg setImage:[UIImage imageNamed:@"wait2-568h.png"]];
    }
    else{
        [self.loadinImg setImage:[UIImage imageNamed:@"wait2.png"]];
    }
}

-(void)scaleOut {
    [UIView animateWithDuration:2.0 animations:^{
        self.greenFill.frame = kInnerFrame(CGPointMake(160, 177+movedown));
    } completion:^(BOOL finished){
        self.greenFill.alpha = 0;
        self.figureImg.image = [UIImage imageNamed:@"7waitlabel_finish@2x.png"];
    }];
    [UIView commitAnimations];
}

-(void)scaleIn {
    [UIView animateWithDuration:2.0 animations:^{
        self.greenFill.frame = kHideFrame(CGPointMake(160, 177+movedown));
    } completion:^(BOOL finished){
        
    }];
    [UIView commitAnimations];
}

-(void)finishLoading {
    [self.greenFill.layer removeAllAnimations];
    self.greenFill.frame = kInnerFrame(CGPointMake(160, 177+movedown));
}

-(void)setLoadinImg:(UIImageView *)tloadinImg{
    loadinImg=tloadinImg;
}

-(void)show{
    [self setHidden:NO];
    [self scaleOut];
}
-(void)hide{
    
    [self finishLoading];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished){
        
        self.figureImg.frame = kHideFrame(self.figureImg.frame.origin);
        self.hidden = YES;
        
    }];
}

//Need To Cancel It If"Back"Button Pressed


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawi/Users/yeke/Desktop/TestUI_2.0 editby_DT_17_1903/TestUI/LoadingView.mng code
}
*/


@end
