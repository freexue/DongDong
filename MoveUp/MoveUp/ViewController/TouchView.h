//
//  TouchView.h
//  TestUI
//
//  Created by Ye Ke on 1/12/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol touchVideoDelegate <NSObject>
  -(void)showTriggerView;
@end

@interface TouchView : UIView {
    id<touchVideoDelegate> touchDelegate;
}

@property(nonatomic, retain)  id<touchVideoDelegate> touchDelegate;

@end
