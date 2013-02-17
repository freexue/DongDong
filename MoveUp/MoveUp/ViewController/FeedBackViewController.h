//
//  FeedBackViewController.h
//  TestUI
//
//  Created by Ke Ye on 9/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"

@interface FeedBackViewController : UIViewController<UITextViewDelegate> {
    IBOutlet UITextView * textView;
}

@property (nonatomic, retain)IBOutlet UITextView * textView;

@end
