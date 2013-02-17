//
//  MixView.m
//  TestUI
//
//  Created by Ke Ye on 8/17/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "MixView.h"
#import "SystemConfig.h"

@implementation MixView
@synthesize tView;
@synthesize touchView;
@synthesize wordView;   // words
@synthesize videoView;  // video
@synthesize image;
@synthesize video;
@synthesize picView;
@synthesize text;

-(void)dealloc {
    
    NSLog(@"mView DEALLOC");
    
    for( UIView *subview in videoView.subviews) {
        [subview removeFromSuperview];
    }
    
    [video release];
    
    //[self.videoView release];
    //[self.wordView release];
    //[self.tView release];
    [super dealloc];
    NSLog(@"mView DEALLOC FINISH");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"InitWithFrame");
        NSLog(@"Frame %f %f %f %f", self.frame.size.width, self.frame.size.height,self.frame.origin.x, self.frame.origin.y);
        
        self.picView =  [[[UIImageView alloc]initWithFrame:self.frame] autorelease];
        self.wordView = [[[UIView alloc]initWithFrame:self.frame] autorelease];
        
        if ([SystemConfig isIphone5]) {
                    self.tView = [[[TouchTextView alloc]initWithFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y -5, self.frame.size.width  , self.frame.size.height-10+58)] autorelease];
                self.videoView = [[[UIView alloc]initWithFrame:CGRectMake(self.frame.origin.x -2 , self.frame.origin.y -5, self.frame.size.width, self.frame.size.height-10+88)] autorelease];
        }
        else{
                    self.tView = [[[TouchTextView alloc]initWithFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y -5, self.frame.size.width  , self.frame.size.height-10)] autorelease];
        
                self.videoView = [[[UIView alloc]initWithFrame:self.frame] autorelease] ;
        }
        
        videoView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.941 alpha:1];
        tView.backgroundColor = [UIColor colorWithRed:0.937 green:0.937 blue:0.941 alpha:1];

        self.touchView = [[[TouchView alloc]initWithFrame:CGRectMake(self.frame.origin.x , self.frame.origin.y -5 , self.frame.size.width , self.frame.size.height )] autorelease];
        
        self.tView.scrollEnabled = YES;
        self.tView.editable = NO;
        
        [self addSubview:wordView];
        [self addSubview:videoView];
        [self.wordView addSubview:tView];
        
        [wordView release];
        [videoView release];
        [tView release];
        
    }
    return self;
}

-(void)configImage:(UIImage *)img {
    
    [self setNeedsDisplay];
}

-(void)configWords:(NSString *)str {
    NSLog(@"Set Text");
    text = str;
    [self setNeedsDisplay];
}

-(void)configVideo:(UIView *)view {
    
    
    for( UIView *subview in videoView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.video = view;
    
    [videoView addSubview:video];
    
    CGSize size = video.frame.size;
    
    if ([SystemConfig isIphone5]) {
        video.frame = CGRectMake(0, 30, 320, 360);
    }
    else {
        video.frame = CGRectMake(video.frame.origin.x , video.frame.origin.y, 324, 360 );
    }
    
    videoView.frame = video.frame;
    [videoView addSubview:touchView];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"MIXView DrawRect");

    tView.font = [UIFont fontWithName:@"Arial" size:20];
    tView.text = text;
    
}

- (void)doUIViewAnimation{
    
    [UIView beginAnimations:@"animationID" context:nil]; 
    [UIView setAnimationDuration:1.0f]; 
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
    [UIView setAnimationRepeatAutoreverses:NO]; 
    
    switch (1) { 
        case 0: 
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];//oglFlip, fromLeft 
            break; 
        case 1: 
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];//oglFlip, fromRight      
            break; 
        case 2: 
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES]; 
            break; 
        case 3: 
            [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES]; 
            break; 
        default: 
            break; 
    }
    [self exchangeSubviewAtIndex:1 withSubviewAtIndex:0]; 
    [UIView commitAnimations];
    
}
@end
