//
//  AMProgressViewGradient.m
//  AMProgressView
//
//  Created by Albert Mata on 15/12/2012.
//  Copyright (c) 2012 Albert Mata. All rights reserved. FreeBSD License.
//  Please send comments/corrections to hello@albertmata.net or @almata on Twitter.
//  Download latest version from https://github.com/almata/AMProgressView
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//

#import "AMProgressViewGradient.h"

@interface AMProgressViewGradient ()
@property (nonatomic) BOOL vertical;
@property (nonatomic, strong) NSMutableArray *gradientColors;
@property (nonatomic, assign)  float progress;
@end

@implementation AMProgressViewGradient

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame andGradientColors:[NSArray arrayWithObject:[UIColor redColor]] andVertical:NO];
}

- (id)initWithFrame:(CGRect)frame andGradientColors:(NSArray *)gradientColors andVertical:(BOOL)vertical
{
    self = [super initWithFrame:frame];
    if (self) {
        self.vertical = vertical;
        self.gradientColors = [NSMutableArray arrayWithArray:gradientColors];
        if ([self.gradientColors count] == 1) {
            self.backgroundColor = (UIColor *)[self.gradientColors objectAtIndex:0];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect //That's Important
{
    if ([self.gradientColors count] == 1) return;
    
    self.gradientColors = [[NSMutableArray alloc] init];
    [self.gradientColors addObject:[UIColor greenColor]];
    [self.gradientColors addObject:[UIColor yellowColor]];
    [self.gradientColors addObject:[UIColor yellowColor]];
    [self.gradientColors addObject:[UIColor redColor]];
    
    CGRect rect1;
    CGRect rect2;
    
    
    self.progress = 0.4;
    if (self.vertical) {
        rect2 = CGRectMake(0, 0, rect.size.width, rect.size.height * (1- self.progress));
        rect1 = CGRectMake(0, rect.size.height * (1- self.progress), rect.size.width, rect.size.height * self.progress);
        [self drawGradiant:rect1 range:2 to:4 ];
        [self drawGradiant:rect2 range:0 to:2 ];
    } else {
        rect1 = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
        rect2 = CGRectMake(rect.size.width * self.progress , 0, rect.size.width * (1.0 - self.progress), rect.size.height);
        
        [self drawGradiant:rect1 range:0 to:2 ];
        [self drawGradiant:rect2 range:2 to:4 ];
    }
   
    
}

- (void)drawGradiant: (CGRect)rect range:(int)start to: (int)end {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int numComponents = 4;
    CGFloat colors[(end - start) * numComponents];
    const CGFloat *components[(end - start)];
    for (int i = start; i < end; i++) {
        components[i-start] = CGColorGetComponents(((UIColor *)[self.gradientColors objectAtIndex:i]).CGColor);
        for (int j = 0; j < numComponents; j++) {
            colors[(i - start) * numComponents + j] = components[i-start][j];
        }
    }
    CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, colors, NULL, end - start);
    
    CGPoint startPoint;
    CGPoint endPoint;
    
    NSLog(@"Rect %f %f %f %f",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    if (self.vertical) {
        startPoint = CGPointMake(rect.origin.x, rect.origin.y);
        endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    } else {
        startPoint = CGPointMake(rect.origin.x,rect.origin.y );
        endPoint = CGPointMake(rect.size.width + rect.origin.x, rect.origin.y );
    }
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end