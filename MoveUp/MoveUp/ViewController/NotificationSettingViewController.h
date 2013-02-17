//
//  NotificationSettingViewController.h
//  TestUI
//
//  Created by FreeXue on 13-1-5.
//  Copyright (c) 2013年 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AddNoti,
    UpdateNoti,
    DeleteNoti,
}NotiAction;

@interface NotificationSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView * _tableView;
    NSMutableArray * listData;
    NSArray * listData1;
    IBOutlet UIScrollView *scrollview;
    UIButton *efButton ;
    BOOL btnswith;
    UIButton* finishsetting;
    NSMutableArray * weekdays;
    NSMutableArray * notis;
    
    IBOutlet UIPickerView * picker;
    IBOutlet UIView * popUpView;
    IBOutlet UIButton * okBtn;
    IBOutlet UIButton * cancelBtn;
    
    NSArray * hourArr;
    NSArray * minutesArr;
    NotiAction notiAction;
    
    int modifying_noti_index;
    
}
@property( nonatomic, assign) UIButton* finishsetting;
@property( nonatomic, assign) BOOL btnswith;
@property ( nonatomic, retain) UIButton *efButton ;
@property ( nonatomic, retain) NSMutableArray *infoData;
@property ( nonatomic, retain)  NSMutableArray * listData;
@property ( nonatomic, retain)  NSArray * listData1;
@property ( nonatomic, retain) NSMutableArray * notis;
@property ( nonatomic, retain) IBOutlet UITableView * _tableView;
@property ( nonatomic, retain)  IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) NSArray * hourArr;
@property (nonatomic, retain) NSArray * minutesArr;

@end
