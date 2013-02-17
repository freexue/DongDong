//
//  DescriptionView.h
//  TestUI
//
//  Created by FreeXue on 13-2-2.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescriptionView : UIView{
    UILabel *parts;
    UILabel *averageTimes;
    UILabel *healthStatus;
    UIImageView *background;
}
@property (nonatomic, retain) UILabel *parts;
@property (nonatomic, retain) UILabel *averageTimes;
@property (nonatomic, retain) UILabel *healthStatus;
@property (nonatomic, retain) UIImageView *background;


-(void)setPos:(UIButton *)click;
-(void)Disappear;
@end
