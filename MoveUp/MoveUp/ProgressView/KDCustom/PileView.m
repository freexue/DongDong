//
//  PileView.m
//  TestUI
//
//  Created by Ye Ke on 1/8/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "PileView.h"



#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)

@implementation PileView
@synthesize percent, color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    [super drawRect:rect];
}

-(void)drawInContext:(CGContextRef)ctx
{
    // Drawing code
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = -1 * toRadians(360 * (1 - percent));
    
    CGFloat innerRadius = 23.5;
    CGFloat outerRadius = 28.5;
    
    if (color) {
        CGContextSetFillColorWithColor(ctx, color.CGColor);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:110/256.0 green:204/256.0 blue:41/256.0 alpha:1.0f].CGColor);
    }
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CFRelease(path);
}


@end
