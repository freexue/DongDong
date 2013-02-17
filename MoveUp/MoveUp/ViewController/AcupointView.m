//
//  AcupointView.m
//  TestUI
//
//  Created by Ye Ke on 1/14/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "AcupointView.h"

#define CELL_CONTENT_WIDTH 232.0f
#define CELL_CONTENT_MARGIN 5.0f

@implementation AcupointView
@synthesize acImg;
@synthesize description;

- (id)initWithFrame:(CGRect)frame andDescription:(NSString *)dscrp andImage:(UIImage *)img
{
    self = [super initWithFrame:frame];
    if (self) {
        description = dscrp;
        acImg = img;
        /*
        textView =  [[UITextView alloc] init];
        imgView = [[UIImageView alloc]init];
        [self addSubview:textView];
        [self addSubview:imgView];
        */
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    textView.text = description;
    textView.userInteractionEnabled = NO;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [description sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    textView.text = description;
    textView.frame = CGRectMake(0, 0, 232, size.height + 20);
    textView.scrollEnabled = YES;
    textView.contentSize = size;
    imgView.image = acImg;
    //[imgView sizeToFit];
    
    imgView.center = CGPointMake(imgView.superview.frame.size.width/2.0,imgView.superview.frame.size.height/2.0 - 45);
    textView.center = CGPointMake(imgView.center.x, imgView.center.y + imgView.frame.size.height/2.0 + textView.frame.size.height/2.0 + 10.0f );
    
}

-(void)setAcDesription:(NSString *)text {
    description = text;
    [self setNeedsDisplay];
}

-(void)setImage:(UIImage *)img {
    acImg = img;
    [self setNeedsDisplay];
}


@end
