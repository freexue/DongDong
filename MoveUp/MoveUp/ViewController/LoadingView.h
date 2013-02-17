//
//  LoadingView.h
//  TestUI
//
//  Created by FreeXue on 13-1-16.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFrame(p) CGRectMake(p.x - 32 , p.y - 32, 64, 64)
#define kInnerFrame(p) CGRectMake(p.x - 25, p.y - 26, 50, 52)
#define kHideFrame(p) CGRectMake(p.x - 25, p.y + 26, 50, 0)

@interface LoadingView : UIView{
    //UIActivityIndicatorView *loading;
    //UIImageView * loadinImg;
    //UIImageView * figureImg;
    //UIImageView * blankFill;
    //UIImageView * greenFill;
    float movedown;
}
@property (nonatomic, assign) float movedown;

@property (nonatomic, retain) UIImageView * loadinImg;
@property (nonatomic, retain) UIView * blankFill;
@property (nonatomic, retain) UIView * greenFill;
@property (nonatomic, retain) UIImageView * figureImg;


-(void)show;
-(void)hide;
-(void)setSecondImage;
@end
