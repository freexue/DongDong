//
//  IllustrationView.m
//  TestUI
//
//  Created by Ye Ke on 2/4/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "IllustrationView.h"
#define kOrigin CGPointMake(0, -300)
#define kShowOut CGPointMake(0, 5)

#define CELL_CONTENT_WIDTH 293.0f
#define CELL_CONTENT_MARGIN 2.0f

#define BOARDLOWER [SystemConfig isIphone5]?446.0f :368.0f
#define BOARDUPPER [SystemConfig isIphone5]?6.0f :6.0f
#define BOARDCENTER [SystemConfig isIphone5]?225.0f:181.0f

@implementation IllustrationView

@synthesize acuView;
@synthesize wordView;
@synthesize controlBtn;
@synthesize showView;
@synthesize acuTitle;
@synthesize accuwdView;
@synthesize wordTitle;
@synthesize hintPlayer;
@synthesize delegate;
@synthesize isBusy;
@synthesize status;
@synthesize disrupted;
@synthesize receiveTouchEnabled;
@synthesize firstIndicationShowing;
@synthesize isPulledByUser;
@synthesize effectView;
@synthesize effectTitle;

-(void)setContent:(Exercise *)ex {
    
    boardCenter = BOARDCENTER;
    boardLower = BOARDLOWER;
    boardUpper = BOARDUPPER;
    
    NSLog(@"SETCONTENT");
    
    [UIView animateWithDuration:0.3 animations:^{
        controlBtn.alpha = 1;
    }];
    
    isFirstTime = YES;
    isPulledByUser = NO;
    
    self.userInteractionEnabled = YES;
    controlBtn.enabled = YES;
    
    //self.acuTitle.text = @"穴位位置";
    //self.wordTitle.text = @"动作要领";
    
    NSRange range = [self getDescriptionPart:ex.content];
    
    self.wordView.scrollEnabled = NO;
    self.effectView.scrollEnabled = NO;
    self.accuwdView.scrollEnabled = NO;
    
    UIColor * color = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:98.0f/255.0f alpha:1.0];
    
    self.wordView.textColor = color;
    self.wordTitle.textColor = color;
    self.effectTitle.textColor = color;
    self.effectView.textColor = color;
    self.acuTitle.textColor = color;
    self.accuwdView.textColor = color;
    
    self.wordView.text = [ex.content substringToIndex:range.location];
    self.effectView.text = [ex.content substringFromIndex:range.location + range.length];
    
    if (ex.hasIndication) {
        self.acuTitle.hidden = NO;
        self.acuView.hidden = NO;
        self.accuwdView.hidden = NO;
        
        NSString * soundFilePath = [[NSBundle mainBundle] pathForResource:ex.i_SoundPath ofType:@"mp3"]; //The Output
        NSURL * soundURL= [[NSURL alloc] initFileURLWithPath:soundFilePath];
        NSError * error = nil;
        
        //if (ex.exNum == 0) {
        self.hintPlayer = [[[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:&error] autorelease];
        hintPlayer.volume = 3;
        [hintPlayer setNumberOfLoops:0];
        hintPlayer.delegate = self;
        
        [soundURL release];
        //}
        
        acuView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", ex.i_ImagePath]];
        
        accuwdView.userInteractionEnabled = NO;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [ex.i_Description sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        accuwdView.contentSize = CGSizeMake(size.width, size.height );
        accuwdView.text = ex.i_Description;
        accuwdView.frame = CGRectMake(acuTitle.frame.origin.x, acuTitle.frame.origin.y + acuTitle.frame.size.height , size.width, size.height + 35);
        //accuwdView.backgroundColor = [UIColor redColor];
        
        wordTitle.frame = CGRectMake(accuwdView.frame.origin.x,accuwdView.frame.origin.y + accuwdView.frame.size.height +5 , wordTitle.frame.size.width, wordTitle.frame.size.height);
        //wordView.backgroundColor = [UIColor blueColor];
        wordView.userInteractionEnabled = NO;
        constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        size = [wordView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        wordView.contentSize = CGSizeMake(size.width, size.height );
        wordView.frame = CGRectMake(wordTitle.frame.origin.x, wordTitle.frame.origin.y + wordTitle.frame.size.height, size.width, size.height + 35 );
        
        constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        size = [effectView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        effectTitle.frame = CGRectMake(wordView.frame.origin.x,wordView.frame.origin.y + wordView.frame.size.height + 5, effectTitle.frame.size.width, effectTitle.frame.size.height);
        
        effectView.contentSize = CGSizeMake(size.width, size.height );
        effectView.frame = CGRectMake(effectTitle.frame.origin.x, effectTitle.frame.origin.y + effectTitle.frame.size.height, size.width, size.height + 35);
        
        showView.contentSize = CGSizeMake(effectView.frame.size.width, effectView.frame.origin.y + effectView.frame.size.height + 40);
    }
    else {
        
        if (self.hintPlayer) {
            [self.hintPlayer stop];
            self.hintPlayer.delegate = nil;
            [hintPlayer release];
            hintPlayer = nil;
        }
        
        self.acuTitle.hidden = YES;
        self.acuView.hidden = YES;
        self.accuwdView.hidden = YES;
        
        wordTitle.frame = CGRectMake(20, 52, wordTitle.frame.size.width, wordTitle.frame.size.height);
        
        wordView.userInteractionEnabled = NO;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGSize size = [wordView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        wordView.contentSize = CGSizeMake(size.width, size.height );
        wordView.frame = CGRectMake(wordTitle.frame.origin.x, wordTitle.frame.origin.y + wordTitle.frame.size.height , size.width, size.height + 35);
        
        constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        size = [effectView.text sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        effectTitle.frame = CGRectMake(wordView.frame.origin.x,wordView.frame.origin.y + wordView.frame.size.height +5, effectTitle.frame.size.width, effectTitle.frame.size.height);
        
        effectView.contentSize = CGSizeMake(size.width, size.height );
        effectView.frame = CGRectMake(effectTitle.frame.origin.x, effectTitle.frame.origin.y + effectTitle.frame.size.height, size.width, size.height + 35);
        
        showView.contentSize = CGSizeMake(effectView.frame.size.width, effectView.frame.origin.y + effectView.frame.size.height + 40);
    }
    
    [showView setNeedsDisplay];
    [self setNeedsDisplay];
}

-(NSRange)getDescriptionPart:(NSString *)content {
    
    NSString * keyWords = @"Part2";
    NSRange range = [content rangeOfString:keyWords];
    
    return range;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        status = kAtUpSide;
        
    }
    return self;
}

- (void)stopPlayer {
    
    if ((status == kAtDownSide) || (status == kAtUpSide && isBusy)) {
        [self goUp];
    }
    
    if (self.hintPlayer) {
        [self.hintPlayer stop];
        self.hintPlayer.delegate = nil;
        [hintPlayer release];
        hintPlayer = nil;
    }
    
    self.userInteractionEnabled = NO;
    controlBtn.enabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        controlBtn.alpha = 0.5;
    }];
    
}

- (void)dragBegan:(UIControl *)c withEvent:ev {

    UITouch *touch = [[ev allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    heightDiff = touchPoint.y - controlBtn.center.y;
    
    NSLog(@"start center=====Y %f", controlBtn.center.y);
}

- (void)dragMoving:(UIControl *)c withEvent:ev {
    
    if (receiveTouchEnabled ) {
        
        isBusy = YES;
        UITouch *touch = [[ev allTouches] anyObject];
        CGPoint touchPoint = [touch locationInView:self.superview];
        
        CGPoint center = CGPointMake(controlBtn.frame.origin.x + 55, touchPoint.y - heightDiff);
        
        NSLog(@"center=====Y %f", center.y);
        if(center.y <= boardUpper ) {
            center.y = boardUpper + 1;
        }
        else if(center.y >= boardLower) {
            center.y = boardLower - 1;
        }
        
        controlBtn.center = center;
        self.center = CGPointMake(160, controlBtn.center.y - boardCenter);
        
        if (delegate!=nil)
        [delegate filterBG: center.y / (boardLower - boardUpper) ];
    }
}

- (void)dragEnded:(UIControl *)c withEvent:ev {
    
    NSLog(@"%f",controlBtn.center.y);
    if(controlBtn.center.y != boardLower && controlBtn.center.y!= 6.0f)
    {
        if (status == kAtDownSide) { //Go Up
            
            float screenHight = [SystemConfig isIphone5]? 504.0f:416.0f;
            
            if (controlBtn.center.y >= screenHight -  88.0f) {
                [self goDown];
            }
            else
                [self goUp];
        }
        else { // Go Down
            if (controlBtn.center.y <= 23.0f)
                [self goUp];
            else
                [self goDown];
        }
    }
    else {
        isBusy = YES;
    }
}

- (void)popbackALittle {
    
    if(!((!isBusy && status == kAtUpSide) || status == kAtDownSide)) {
        if (!isBusy) {
            [UIView animateWithDuration:0.4 animations:^{
                CGPoint center = CGPointMake(controlBtn.frame.origin.x + 55, 6);
                controlBtn.center = center;
                self.center = CGPointMake(160, controlBtn.center.y - boardCenter);
            }];
            [UIView commitAnimations];
        }
    }
    
}

- (void) popoutALittle {
    
    if (!((!isBusy && status == kAtUpSide) || status == kAtDownSide)) {
        [UIView animateWithDuration:0.4 animations:^{
            CGPoint center = CGPointMake(controlBtn.frame.origin.x + 55, 16);
            controlBtn.center = center;
            self.center = CGPointMake(160, controlBtn.center.y - boardCenter);
        }];
        [UIView commitAnimations];
    }
    
}



-(void)goDown {
    
    receiveTouchEnabled = NO;
    float duration = (1 - controlBtn.center.y / ( boardLower - 6.0f )) * 0.8;
    
    UIImage * img = [UIImage imageNamed:@"7pull_up.png"];
    
    [controlBtn setImage:img forState:UIControlStateNormal];
    [controlBtn setImage:img forState:UIControlStateHighlighted];
    
    if (delegate!=nil) {
        [delegate filterBG: 1.0 duration:duration];
    }
    
    CGPoint center = CGPointMake(controlBtn.frame.origin.x + 55, boardLower);
    
    [UIView animateWithDuration:duration animations:^{
        
        controlBtn.center = center;
        self.center = CGPointMake(160, controlBtn.center.y - boardCenter);
        self.userInteractionEnabled = NO;
        
    } completion:^(BOOL isfinished) {
        
        isPulledByUser = YES;
        
        self.userInteractionEnabled = YES;
        status = kAtDownSide;
        
        if (hintPlayer && isFirstTime) {
            NSLog(@"Come Into FirstTime");
            hintPlayer.currentTime = 0.0;
            [hintPlayer play];
            isFirstTime = NO;
        }
        
        if (controlBtn.enabled) {
            receiveTouchEnabled = YES;
        }
        
        if (delegate) {
            [delegate stopPlay];
        }
        isBusy = NO;
    }];
}

-(void)goUp {
    
    receiveTouchEnabled = NO;
    float duration = ( controlBtn.center.y / ( boardLower + 22.0f )) * 0.8;
    
    UIImage * img = [UIImage imageNamed:@"7pull_down.png"];
    
    [controlBtn setImage:img forState:UIControlStateNormal];
    [controlBtn setImage:img forState:UIControlStateHighlighted];
    
    if (delegate!=nil) {
        [delegate filterBG: 0.0 duration: duration];
    }
    
    CGPoint center = CGPointMake(controlBtn.frame.origin.x + 55, 6.0f);
    [UIView animateWithDuration: duration animations:^{
        
        controlBtn.center = center;
        self.center = CGPointMake(160, controlBtn.center.y - boardCenter);
        self.userInteractionEnabled = NO;
        
    } completion:^(BOOL isfinished) {
        
        isPulledByUser = YES;
        
        self.userInteractionEnabled = YES;
        status = kAtUpSide;
        
        if (hintPlayer)
        {
            [hintPlayer stop];
        }
        
        if (controlBtn.enabled) {
            receiveTouchEnabled = YES;
        }
        
        if (delegate!=nil){
            [delegate filterBG: center.y / (boardLower - boardUpper) ];
            [delegate continuePlay];
        }
        isBusy = NO;
    }];
    //[UIView commitAnimations];
}



#pragma mark Audio Delegate


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"BeginInterruption");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    NSLog(@"EndInterruption");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    if (firstIndicationShowing) {
        [self goUp];
    }
    NSLog(@"Interuption For Stop");
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    [controlBtn addTarget:self action:@selector(dragBegan:withEvent:) forControlEvents: UIControlEventTouchDown];
    [controlBtn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents: UIControlEventTouchDragInside];
    [controlBtn addTarget:self action:@selector(dragEnded:withEvent:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    // Drawing code
}

@end
