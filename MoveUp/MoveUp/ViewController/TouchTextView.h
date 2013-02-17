//
//  TouchTextView.h
//  TestUI
//
//  Created by Ke Ye on 8/22/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol touchDelegate <NSObject>
  -(void)showTriggerView;
@end

@interface TouchTextView : UITextView {
    id<touchDelegate> touchDelegate;
}

@property(nonatomic, retain)  id<touchDelegate> touchDelegate;


@end
