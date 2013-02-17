//
//  AchieveView.h
//  TestUI
//
//  Created by Ke Ye on 8/15/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AchieveViewController : UIViewController {
    
    IBOutlet UILabel * titleL;
    IBOutlet UILabel * description;
    IBOutlet UIImageView * imgView;
    
    NSString * nameStr;
    NSString * contentStr;
    NSString * imgStr;
}

@property (nonatomic, retain) IBOutlet UILabel * titleL;
@property (nonatomic, retain) IBOutlet UILabel * description;
@property (nonatomic, retain) IBOutlet UIImageView * imgView;

-(void)InitInfo:(NSString *)name and:(NSString *)content and:(NSString *)img;
-(void)showUp;

@end
