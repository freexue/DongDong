//
//  ManageViewController.h
//  TestUI
//
//  Created by Ke Ye on 8/6/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageMenuCell.h"

@interface ManageViewController :UIViewController<UITableViewDelegate, UITableViewDataSource> {
    //    IBOutlet NSMutableArray * dataSource;
        IBOutlet UITableView * _tableView;
        IBOutlet ManageMenuCell * manageCell;
}

@property(nonatomic, retain) IBOutlet ManageMenuCell * manageCell;

@end
