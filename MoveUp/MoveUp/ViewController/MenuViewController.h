//
//  MenuViewController.h
//  TestUI
//
//  Created by Ke Ye on 8/1/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuCell.h"
#import "UAModalPanel.h"
#import "ResultViewController.h"




@interface MenuViewController : UIViewController<UIActionSheetDelegate, UIAlertViewDelegate,UAModalPanelDelegate,UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UITableView * _tableView;
    IBOutlet NSMutableArray * dataSource;
    IBOutlet MenuCell * menuCell;
    IBOutlet UIButton * adBtn;
    UAModalPanel * modalPanel;
    UIViewController * coverVC;
    ResultViewController * resultViewController;

}

@property (nonatomic, retain) IBOutlet MenuCell * menuCell;
@property (nonatomic, retain) IBOutlet UIButton * adBtn;


@end
