//
//  TriggerView.h
//  TestUI
//
//  Created by Ke Ye on 8/10/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TriggerView : UIView {
    NSMutableArray * orders;
    int currentNum;
    NSMutableArray * btns;
}

-(void)InitOrder:(NSMutableArray *)arr;
-(void)GoNextPanel;

@end
