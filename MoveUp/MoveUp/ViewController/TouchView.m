//
//  TouchView.m
//  TestUI
//
//  Created by Ye Ke on 1/12/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView

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

@end
