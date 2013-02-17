//
//  AchieveView.m
//  TestUI
//
//  Created by Ke Ye on 8/15/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "AchieveViewController.h"
#import "StarPanel.h"

@implementation AchieveViewController     

@synthesize titleL;
@synthesize description;
@synthesize imgView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        nameStr = @"Default";
        contentStr = @"Default";
        imgStr = @"";
    }
    return self;
}

-(void)InitInfo:(NSString *)name and:(NSString *)content and:(NSString *)img {
    nameStr = [NSString stringWithFormat:@"您已获得\"%@\"!",name];
    contentStr = content;
    imgStr = img;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleL.text = nameStr;
    description.text = contentStr;
    imgView.image = [UIImage imageNamed:imgStr];
    
    NSLog(@"ViewDidLoad");
    StarPanel * sp = [[StarPanel alloc] initWithFrame:CGRectMake(-160, 0, 640, 300)];
    sp.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sp];
}

-(void)showUp {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished){
    }];
    
    [UIView commitAnimations];
}

@end
