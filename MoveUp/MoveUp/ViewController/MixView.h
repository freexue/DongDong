//
//  MixView.h
//  TestUI
//
//  Created by Ke Ye on 8/17/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTextView.h"
#import "TouchView.h"

@interface MixView : UIView {
    UIImageView * picView;  //picture
    UIView * wordView;   // words
    UIView * videoView;  // video
    TouchTextView * tView;
    TouchView * touchView;
    NSString * text;
    UIImage * image;
    UIView * video;
}

@property(nonatomic, retain) TouchTextView * tView;
@property(nonatomic, retain) TouchView * touchView;
@property(nonatomic, retain) UIView * wordView;   // words
@property(nonatomic, retain) UIView * videoView;  // video
@property(nonatomic, retain) UIImage * image;
@property(nonatomic, retain) UIView * video;
@property(nonatomic, retain) UIImageView * picView;
@property(nonatomic, retain) NSString * text;


-(void)doUIViewAnimation;
-(void)configImage:(UIImage *)img;
-(void)configWords:(NSString *)str;
-(void)configVideo:(UIView *)view;

@end
