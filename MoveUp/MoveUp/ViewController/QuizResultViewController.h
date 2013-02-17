//
//  NoticeViewController.h
//  TestUI
//
//  Created by Ye Ke on 1/9/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeViewController.h"


@interface QuizResultViewController : UIViewController {
    IBOutlet UIButton * OKButton;
    IBOutlet UILabel * titleLbl;
    IBOutlet UITextView * contentView;
    IBOutlet UITextView * healthstatus;
    IBOutlet UITextView * partlbl;
    IBOutlet UITextView * partlbltitle;
    IBOutlet UIImageView * shade;
    IBOutlet UIImageView * panel;
    IBOutlet UIView * window;

    id<NoticeViewDelegate> delegate;
    
    NSString * title;
    NSString * content;
    
    NSArray * partsName;
}
@property(nonatomic, retain) NSArray * partsName;
@property(nonatomic, retain) id<NoticeViewDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel * titleLbl;
@property(nonatomic, retain) IBOutlet UITextView * contentView;
@property(nonatomic, retain)  IBOutlet IBOutlet UITextView * healthstatus;
@property(nonatomic, retain)  IBOutlet IBOutlet UITextView * partlbl;
@property(nonatomic, retain)  IBOutlet IBOutlet UITextView * partlbltitle;
@property(nonatomic, retain)  IBOutlet UIView * window;


-(void)setContent:(NSString *)str;
-(void)setTitle:(NSString *)ttitle;
-(void)show;
-(void)hidden;
-(void)disappear;
@end
