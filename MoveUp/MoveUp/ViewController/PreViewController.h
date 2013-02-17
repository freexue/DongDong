//
//  ViewController.h
//  TestUI
//
//  Created by Ke Ye on 7/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomedPC.h"

@interface PreViewController : UIViewController<UIScrollViewDelegate> {
   IBOutlet CustomedPC * pcView;
   IBOutlet UIScrollView * scrollView;
   IBOutlet UIButton * nextBtn;
}
  
@property (nonatomic, retain) IBOutlet CustomedPC * pcView;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UIButton * nextBtn;

@end
