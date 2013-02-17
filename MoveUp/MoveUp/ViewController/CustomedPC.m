//
//  CustomedPC.m
//  TestUI
//
//  Created by Ke Ye on 7/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "CustomedPC.h"

@interface CustomedPC(private)  // 声明一个私有方法, 该方法不允许对象直接使用
    - (void)updateDots;
@end

@implementation CustomedPC

@synthesize imagePageStateNormal;
@synthesize imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [imagePageStateHighlighted release];
    imagePageStateHighlighted = [image retain];
    [self updateDots];
}

- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [imagePageStateNormal release];
    imagePageStateNormal = [image retain];
    [self updateDots];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    if (imagePageStateNormal || imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            dot.image = self.currentPage == i ? imagePageStateNormal : imagePageStateHighlighted;
        }
    }
}

@end
