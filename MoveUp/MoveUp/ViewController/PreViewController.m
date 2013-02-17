//
//  ViewController.m
//  TestUI
//
//  Created by Ke Ye on 7/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "PreViewController.h"
#import "PlayViewController.h"
#import "DetailViewController.h"
#import "UserData.h"
#import "FTAnimation.h"

#define PNGFor(x) [NSString stringWithFormat: @"%@.png", x]

@implementation PreViewController
@synthesize pcView;
@synthesize scrollView;
@synthesize nextBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.hidesBackButton = YES;
    scrollView.contentSize = CGSizeMake(1600, 128);
    scrollView.delegate = self;
    
    [pcView setCurrentPage:0];
    [pcView setImagePageStateNormal:[UIImage imageNamed:@"1dot.png"]];//灰色圆点图片
    [pcView setImagePageStateHighlighted:[UIImage imageNamed:@"1dot_selected.png"]];//黑色圆点图片
    pcView.currentPage = 0;
    [pcView setHidesForSinglePage:YES];
    [pcView addTarget:self action:@selector(adjustScrollView:) forControlEvents:UIControlEventValueChanged];
    pcView.numberOfPages = 5;

    
    self.navigationItem.title=@"办公室健身操";
    [self InitPages];
    
    
}

-(void)adjustScrollView:(id)sender {
    //
    int page = pcView.currentPage;
    scrollView.contentOffset = CGPointMake(page * 320, 0);
}

-(void)InitPages {
    
    CGRect pageRect = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height -20);
    CGRect imageRect = CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height - 20);
    
    UIView *page1 = [[UIView alloc] initWithFrame:pageRect];
    page1.backgroundColor = [UIColor clearColor];
    //[page1 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"1intro_1.png"]]];
    UIView *page2 = [[UIView alloc] initWithFrame:pageRect];
    page2.backgroundColor=[UIColor clearColor];
    //[page2 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"fengmian2.png"]]];
    UIView *page3 = [[UIView alloc] initWithFrame:pageRect];
    page3.backgroundColor = [UIColor clearColor];
    
    UIView *page4 = [[UIView alloc] initWithFrame:pageRect];
    page4.backgroundColor = [UIColor clearColor];
    
    UIView *page5 = [[UIView alloc] initWithFrame:pageRect];
    page5.backgroundColor = [UIColor clearColor];
    
    UIImageView *page1image;
    UIImageView *page2image;
    UIImageView *page3image;
    UIImageView *page4image;
    UIImageView *page5image;
   
    
    page1image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:PNGFor(XIBNameFor(@"1intro_1"))]];
    page1image.frame=imageRect;
    page2image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:PNGFor(XIBNameFor(@"1intro_2"))]];
    page2image.frame=imageRect;
    page3image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:PNGFor(XIBNameFor(@"1intro_3"))]];
    page3image.frame=imageRect;
    page4image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:PNGFor(XIBNameFor(@"1intro_4"))]];
    page4image.frame=imageRect;
    page5image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:PNGFor(XIBNameFor(@"1intro_5"))]];
    page5image.frame=imageRect;
    
    [page1 addSubview:page1image];
    [page2 addSubview:page2image];
    [page3 addSubview:page3image];
    [page4 addSubview:page4image];
    [page5 addSubview:page5image];
    
    [page1image release];
    [page2image release];
    [page3image release];
    [page4image release];
    [page5image release];
    
    UIButton * goNext = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(![SystemConfig isIphone5])
    goNext.frame = CGRectMake(68, 393, 166, 36);
    else
    goNext.frame = CGRectMake(66, 494, 166, 36);
    
    [goNext setImage:[UIImage imageNamed:@"1submit@2x.png"] forState:UIControlStateNormal];
    [goNext setImage:[UIImage imageNamed:@"1submit_selected@2x.png"] forState:UIControlStateHighlighted];
    
    [goNext addTarget:self action:@selector(goNext:) forControlEvents:UIControlEventTouchUpInside];
    
    [page5 addSubview:goNext];
    
    //[page3 setBackgroundColor: [UIColor colorWithPatternImage: [UIImage imageNamed: @"fengmian3.png"]]];
    
    [self loadScrollViewWithPage:page1 withCount:0];
    [self loadScrollViewWithPage:page2 withCount:1];
    [self loadScrollViewWithPage:page3 withCount:2];
    [self loadScrollViewWithPage:page4 withCount:3];
    [self loadScrollViewWithPage:page5 withCount:4];
    
    [page1 release];
    [page2 release];
    [page3 release];
    [page4 release];
    [page5 release];
}

-(IBAction)goNext:(id)sender {
    
    [[UserData sharedUser] createID];
    
    NSDate * dt2 = [UserData sharedUser].lastdt;
    NSLog(@" viewController will appear %@", [dt2 description]);
    
    DetailViewController *bodyVC;
    
    if ([SystemConfig isIphone5]) {
        bodyVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController-568h" bundle:nil];
    }
    else {
        bodyVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.8];
    [animation setType:@"pageCurl"]; //淡入淡出pageCurl
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    
    [self.navigationController pushViewController:bodyVC animated:NO];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"introFinished"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    int offx = sender.contentOffset.x;
    int page = floor((offx ) / 320) ;
    NSLog(@"OffSet %d", offx);
    pcView.currentPage = page;
}


- (void)loadScrollViewWithPage:(UIView *)page withCount:(int)count
{
    
    CGRect bounds = scrollView.bounds;
    bounds.origin.x = bounds.size.width * count;

    bounds.origin.y = 0;
    page.frame = bounds;
    [scrollView addSubview:page];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
