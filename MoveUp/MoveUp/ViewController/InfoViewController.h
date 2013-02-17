//
//  InfoViewController.h
//  TestUI
//
//  Created by Ke Ye on 8/3/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    onNoti1,
    onNoti2,
    onweek,
    unfocused
}state;

@interface InfoViewController : UIViewController<UIAlertViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource> {
    IBOutlet UITableView * table;
    IBOutlet UISlider * sitSlider;
    IBOutlet UISlider * compSlider;
    IBOutlet UILabel * sitLbl;
    IBOutlet UILabel * compLbl;
    
    IBOutlet UIView * popUpView;
    IBOutlet UIPickerView * picker;
    IBOutlet UIButton * okBtn;
  
    IBOutlet UIButton * noti1Btn;
    IBOutlet UIButton * noti2Btn;
    IBOutlet UIButton * male;
    IBOutlet UIButton * female;
    IBOutlet UIImageView * selected;
    
    IBOutlet UIButton * circuBtn;
    
    IBOutlet UIScrollView * scrollView;
    
    IBOutlet UIPickerView * circuView;
    
    NSDictionary * NotiTimes;
    NSArray *secondArr;
    NSArray * noonArr;
    NSArray * morningArr;
    NSArray * pickerSource;
    NSArray * type;
    
    IBOutlet UILabel * n1lb1;
    IBOutlet UILabel * n1lb2;
    IBOutlet UILabel * n2lb1;
    IBOutlet UILabel * n2lb2;
    
    IBOutlet UILabel * cirlb;
}
@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) IBOutlet UILabel * cirlb;
@property (nonatomic, retain) IBOutlet UIButton * circuBtn;
@property (nonatomic, retain) IBOutlet UIPickerView * circuView;
@property (nonatomic, retain) IBOutlet UISlider * sitSlider;
@property (nonatomic, retain) IBOutlet UISlider * compSlider;
@property (nonatomic, retain) IBOutlet UILabel * sitLbl;
@property (nonatomic, retain) IBOutlet UILabel * compLbl;
@property (nonatomic, retain) IBOutlet UIView * popUpView;
@property (nonatomic, retain) IBOutlet UIPickerView * picker;
@property (nonatomic, retain) IBOutlet UIButton * okBtn;
@property (nonatomic, retain) IBOutlet UIButton * cancelBtn;
@property (nonatomic, retain) IBOutlet UIButton * noti0Btn;
@property (nonatomic, retain) IBOutlet UIButton * noti1Btn;
@property (nonatomic, retain) IBOutlet UIButton * noti2Btn;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;

@property (nonatomic, retain) IBOutlet UIButton * male;
@property (nonatomic, retain) IBOutlet UIButton * female;
@property (nonatomic, retain) IBOutlet UIImageView * selected;

@property (nonatomic, retain) IBOutlet NSArray *secondArr;
@property (nonatomic, retain) IBOutlet NSArray * noonArr;
@property (nonatomic, retain) IBOutlet NSArray * morningArr;
@property (nonatomic, retain) IBOutlet NSArray * pickerSource;
@property (nonatomic, retain) IBOutlet NSArray * type;

@property (nonatomic, retain) IBOutlet UILabel * n1lb1;
@property (nonatomic, retain) IBOutlet UILabel * n1lb2;
@property (nonatomic, retain) IBOutlet UILabel * n2lb1;
@property (nonatomic, retain) IBOutlet UILabel * n2lb2;

-(IBAction)selectGender:(id)Sender;

@end
