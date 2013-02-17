//
//  DetailViewController.h
//  TestUI
//
//  Created by FreeXue on 13-1-3.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizResultViewController.h"
#import "NoticeViewController.h"

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, NoticeViewDelegate,UITextFieldDelegate,UIScrollViewDelegate> {
    IBOutlet UITableView * _tableView;
    NSArray * listData;

    IBOutlet UIScrollView *scrollview;
    NSMutableArray *infoData;
     NSMutableArray *detailData;
    UIButton *finishquiz;
    IBOutlet UIView *result;
    UISegmentedControl *sex;
    
    QuizResultViewController * quizresultViewController;
    NoticeViewController * notiViewController;
    IBOutlet UITextField * ageField;
    
    UIButton * doneInKeyboardButton;
    float normalKeyboardHeight;
    IBOutlet UIButton *canedit;
}
@property ( nonatomic, retain) UISegmentedControl *sex;
@property ( nonatomic, retain)   IBOutlet UIButton *canedit;
@property ( nonatomic, retain) IBOutlet UIView *result;
@property ( nonatomic, retain) UIButton *finishquiz;
@property ( nonatomic, retain) NSArray *listData;
@property ( nonatomic, retain) NSMutableArray *detailData;
@property ( nonatomic, retain) NSMutableArray *infoData;
@property ( nonatomic, retain) IBOutlet UITableView * _tableView;
@property ( nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property ( nonatomic, retain) IBOutlet UITextField * ageField;

-(IBAction)goSetting:(id)sender;
-(IBAction)canedit:(id)sender;
@end
