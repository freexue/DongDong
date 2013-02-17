//
//  NoticeViewController.m
//  TestUI
//
//  Created by Ye Ke on 1/9/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "NoticeViewController.h"
#import "FTAnimation.h"
@interface NoticeViewController ()

@end

#define CELL_CONTENT_WIDTH 232.0f
#define CELL_CONTENT_MARGIN 5.0f

#define OK_x 164 + 55
#define other_x 39 + 55

@implementation NoticeViewController
//@synthesize delegate;
@synthesize delegate;
@synthesize contentView;
@synthesize titleLbl;
@synthesize window;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom Initialization
        
    }
    return self;
}

-(void)setContent:(NSString *)str {
    content  = str;
}

-(void)setTitle:(NSString *)ttitle {
    title = ttitle;
}

-(void)viewDidAppear:(BOOL)animated {
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    self.contentView.text = content;
    self.contentView.frame = CGRectMake(0, 0, 232, size.height + 20);
    self.contentView.scrollEnabled = YES;
    self.contentView.contentSize = size;
    self.contentView.center = CGPointMake(self.view.frame.size.width/2.0,self.view.frame.size.height/2.0);
    
    NSLog(@"%f %f", self.contentView.center.x, self.contentView.center.y);
    [self adjustView];
}

-(void)adjustView {
    
    if (notiType == kMixedType) {
        
        
        OKButton.hidden = NO;
        self.titleLbl.text = title;
        self.titleLbl.center = self.contentView.center;
        [self moveDownorUp:titleLbl for: -((contentView.frame.size.height + titleLbl.frame.size.height )/2 + 5.0) ];
        OKButton.center = CGPointMake(OK_x,contentView.center.y);
        otherButton.center = CGPointMake(other_x,contentView.center.y);
        
        [self moveDownorUp:OKButton for: (contentView.frame.size.height + OKButton.frame.size.height )/2 + 5.0 ];
        
        [self moveDownorUp:otherButton for: (contentView.frame.size.height + otherButton.frame.size.height )/2 + 5.0 ];
        
        float px = [UIScreen mainScreen].bounds.size.width/2.0;
        float py = (titleLbl.center.y + OKButton.center.y + 10)/2.0;
        
        float height = (OKButton.frame.origin.y + OKButton.frame.size.height/2.0) - (titleLbl.frame.origin.y  - titleLbl.frame.size.height/2.0);
        
        CGPoint center = CGPointMake(px, py);
        
        panel.frame = CGRectMake(0, 0, 272, height);
        panel.center = center;
    }
    else {
        
        [otherButton setTitle:@"确定" forState:UIControlStateNormal];
        
        self.titleLbl.center = self.contentView.center;
        self.titleLbl.text = title;
        [self moveDownorUp:titleLbl for: -((contentView.frame.size.height + titleLbl.frame.size.height )/2 + 5.0) ];
        otherButton.center = CGPointMake(contentView.center.x,contentView.center.y);
        
        [self moveDownorUp:otherButton for: (contentView.frame.size.height + otherButton.frame.size.height )/2 + 5.0 ];
        
        float px = [UIScreen mainScreen].bounds.size.width/2.0;
        float py = (titleLbl.center.y + otherButton.center.y + 10)/2.0;
        
        float height = (otherButton.frame.origin.y + otherButton.frame.size.height/2.0) - (titleLbl.frame.origin.y  - titleLbl.frame.size.height/2.0);
        
        CGPoint center = CGPointMake(px, py);
        
        panel.frame = CGRectMake(0, 0, 272, height);
        panel.center = center;
        
        OKButton.hidden = YES;
    }
}

-(void)moveDownorUp:(UIView *)view for:(int)height {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + height, view.frame.size.width, view.frame.size.height);
}

-(void)show {
//    
//    self.view.alpha = 0;
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.alpha = 1;
//        [self moveDownorUp:self.view for:-30];
//    }completion:^(BOOL finished){
//        
//    }];
//    [UIView commitAnimations];

    [window popIn:.8 delegate:nil];
    
}

-(void)disappear {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        [self moveDownorUp:self.view for:30];
    }completion:^(BOOL finished){
        self.view.hidden = YES;
    }];
    [UIView commitAnimations];
    
    
}

-(void)setType:(NoticeType)type {
    notiType  = type;
}

-(IBAction)OKPressed:(id)sender {
    [self disappear];
    [delegate OKDidPressed];
}

-(IBAction)otherPressed:(id)sender {
    [self disappear];
    [delegate otherDidPressed];
    
}




@end
