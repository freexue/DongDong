//
//  NoticeViewController.h
//  TestUI
//
//  Created by Ye Ke on 1/9/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    kSimpleType,
    kMixedType,
}NoticeType;

@protocol NoticeViewDelegate

@optional
-(void)OKDidPressed;
-(void)otherDidPressed;

@end

@interface NoticeViewController : UIViewController {
    IBOutlet UIButton * OKButton;
    IBOutlet UIButton * otherButton;
    
    IBOutlet UILabel * titleLbl;
    IBOutlet UITextView * contentView;
    
    IBOutlet UIImageView * shade;
    IBOutlet UIImageView * panel;
    IBOutlet UIView * window;
    NoticeType notiType;
    id<NoticeViewDelegate> delegate;
    
    NSString * title;
    NSString * content;
}

@property(nonatomic, retain) id<NoticeViewDelegate> delegate;
@property(nonatomic, retain) IBOutlet UILabel * titleLbl;
@property(nonatomic, retain) IBOutlet UITextView * contentView;

@property(nonatomic, retain)  IBOutlet UIView * window;

-(void)setType:(NoticeType)type;
-(void)setContent:(NSString *)str;
-(void)setTitle:(NSString *)ttitle;
-(void)show;
-(void)disappear;
@end
