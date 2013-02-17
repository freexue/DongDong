//
//  AcupointView.h
//  TestUI
//
//  Created by Ye Ke on 1/14/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AcupointView : UIView {
    IBOutlet UITextView * textView;
    IBOutlet UIImageView * imgView;
    IBOutlet UIImageView * bgView;
}

@property(nonatomic, retain) UIImage * acImg;
@property(nonatomic, retain) NSString * description;

@end
