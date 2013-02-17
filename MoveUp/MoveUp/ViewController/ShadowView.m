//
//  ShadowView.m
//  TestUI
//
//  Created by Ke Ye on 9/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.frame = [UIScreen mainScreen].bounds;
}

-(void)fadeOut {
     [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        }
     ];
}

-(void)fadeIn {
     [UIView animateWithDuration:0.3 animations:^{
           self.alpha = 1;
        }
     ];
}

@end
