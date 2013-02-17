//
//  ResultViewController.h
//  TestUI
//
//  Created by Ye Ke on 9/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/* Not involved. Prepare for Hongkong Version Update */
@interface ResultViewController : UIViewController<NSURLConnectionDelegate> {
    
    IBOutlet UIButton * cancelBtn;
    IBOutlet UIButton * sendBtn;
    IBOutlet UIButton * announceButton;
    IBOutlet UIActivityIndicatorView * pgView;
    NSMutableData * imageData;
    NSURLConnection * imageConnection;
    NSMutableDictionary * postParams;
    IBOutlet UITextView * textView;
}

@property (nonatomic, retain)  IBOutlet UIButton * cancelBtn;
@property (nonatomic, retain)  IBOutlet UIButton * sendBtn;
@property (strong, nonatomic)  NSMutableData * imageData;
@property (strong, nonatomic)  NSURLConnection * imageConnection;
@property (nonatomic, retain) IBOutlet UITextView * textView;

@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) NSMutableDictionary * postParams;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView * pgView;

@end
