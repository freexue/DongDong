//
//  TouchTextView.m
//  TestUI
//
//  Created by Ke Ye on 8/22/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "TouchTextView.h"

@implementation TouchTextView

@synthesize touchDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"TOUCHES BEGAN!");
    [touchDelegate showTriggerView];
    [[self nextResponder] touchesBegan:touches withEvent:event];
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
