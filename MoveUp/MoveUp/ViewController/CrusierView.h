//
//  CrusierView.h
//  TestUI
//
//  Created by Ye Ke on 1/15/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrusierView : UIView {
    UILabel * crusier;
    UIImageView * bgView;
    
    UILabel * copy_cru;
    UIImageView * copy_bg;
    
    float ori_percent;
}


-(float)oriPercent;
-(void)setOriPercent:(float)pc;
-(void)moveTo:(double)percent withShadowLeft:(BOOL)yes;
-(void)setCopyAlpha:(float)alpha;

@end
