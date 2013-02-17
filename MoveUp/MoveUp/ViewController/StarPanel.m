//
//  StarPanel.m
//  BetaGreatQuiz
//
//  Created by Ke Ye on 7/5/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "StarPanel.h"
#import <QuartzCore/QuartzCore.h>
#define LEFT 0
#define RIGHT 1

@implementation StarPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        side = LEFT;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
   
    for (int i = 0; i< 10; i++) {
        UIImage * img = [UIImage imageNamed:[self RandomColor]];
        UIImageView * star = [[UIImageView alloc] initWithImage:img];
        star.frame = CGRectMake(-100, 100, star.frame.size.width/2, star.frame.size.height/2);
        [self addSubview:star];
        float d = arc4random()%5 /5.0;
        [self performSelector:@selector(TestAnimation:) withObject:star afterDelay:  i*0.2 *d ];
    }
    for (int i = 0; i< 10; i++) {
        UIImage * img = [UIImage imageNamed:[self RandomColor]];
        UIImageView * star = [[UIImageView alloc] initWithImage:img];
        star.frame = CGRectMake(-100, 100, star.frame.size.width, star.frame.size.height);
        [self addSubview:star];
        float d = arc4random()%5 /5.0;
        [self performSelector:@selector(TestAnimation:) withObject:star afterDelay:  i*0.1 *d ];
    }
}


- (void) doAnimation:(UIImageView *)view { 
    CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"]; 
    animation.duration=10.5f; 
    animation.removedOnCompletion = NO; 
    animation.fillMode = kCAFillModeForwards; 
    animation.repeatCount=HUGE_VALF;// repeat forever 
    animation.calculationMode = kCAAnimationCubicPaced; 
    
    CGMutablePathRef curvedPath = CGPathCreateMutable(); 
    CGPathMoveToPoint(curvedPath, NULL, 512, 184); 
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 312, 184, 312, 384); 
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 310, 584, 512, 584); 
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 712, 584, 712, 384); 
    CGPathAddQuadCurveToPoint(curvedPath, NULL, 712, 184, 512, 184); 
    
    //设置起始点 计算加速度
    
    animation.path=curvedPath; 
    [view.layer addAnimation:animation forKey:nil]; 
}

-(NSString *)RandomColor {
    
    int sign = arc4random()%3;
    if (sign == 0) {
        return @"starRed@2x.png";
    }
    else
        return @"starBlue@2x.png";
}

-(int)RandomOffset:(int)offset {
    
    int sign = arc4random() % 2 == 1? (-1):1;
    return sign * arc4random()%offset;
}

-(float) RandomScale{
    int sign = arc4random()%2;
    float scale;
    if(sign == 0)
    {
        scale = 1 + arc4random()%4/4.0;
    }
    else{
        scale = 1.1;
    }
    NSLog(@"SCALE %f" ,scale);
    return scale;
}

-(void)TestAnimation:(UIImageView *)imgView {
                 //贝塞尔曲线路径
         UIBezierPath *movePath = [UIBezierPath bezierPath];
    
    if (side == LEFT) {
        side = RIGHT;
    }
    else{
        side = LEFT;
    }
    
    if (side == LEFT) {
        
        CGPoint sp = CGPointMake(-50.0 + [self RandomOffset:50] , 100.0 + [self RandomOffset:100]);
        CGPoint fp = CGPointMake(320+[self RandomOffset:160], sp.y + [self RandomOffset:125]);
        CGPoint cp = CGPointMake((sp.x + fp.x)/2.0, (sp.y + fp.y)/2.0 - 200 + [self RandomOffset:50] );
        [movePath moveToPoint:sp];
        
        [movePath addQuadCurveToPoint:fp controlPoint:cp];
    }
    else{
        CGPoint sp = CGPointMake(530.0 + [self RandomOffset:50] , 100.0 + [self RandomOffset:100]);
        CGPoint fp = CGPointMake(320+[self RandomOffset:160],sp.y  + [self RandomOffset:125]);
        CGPoint cp = CGPointMake((sp.x + fp.x)/2.0, (sp.y + fp.y)/2.0 -  200 + [self RandomOffset:50] );
        [movePath moveToPoint:sp];
        
        [movePath addQuadCurveToPoint:fp controlPoint:cp];
    }
    
        CAKeyframeAnimation * posAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
         posAnim.path = movePath.CGPath;
    
       //posAnim.removedOnCompletion = YES;
         
         //缩放动画
         CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
         scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    float scale = [self RandomScale];
         scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
         //scaleAnim.removedOnCompletion = YES;
         
         //透明动画
         CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
         opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
         opacityAnim.toValue = [NSNumber numberWithFloat:0.0];
         opacityAnim.beginTime = 1.0;
         //opacityAnim.removedOnCompletion = YES;
         
         //动画组
         CAAnimationGroup *animGroup = [CAAnimationGroup animation];
         animGroup.animations = [NSArray arrayWithObjects: posAnim,scaleAnim,opacityAnim,nil];
         animGroup.duration = 1.5;
         animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];        
        
        [imgView.layer addAnimation:animGroup forKey:nil];
}

-(void)TransAnimation:(UIImageView *)imageView
{
#define PI 3.14159265
    
    CGRect  headImageOrgRect = imageView.frame;
    CGSize size = imageView.image.size;
    
    CGFloat midX = imageView.center.x;
    CGFloat midY = imageView.center.y;
    
    [imageView  setFrame:CGRectMake(0, 0, size.width, size.height)];
    CALayer *TransLayer = imageView.layer;
    
    // Create a keyframe animation to follow a path back to the center
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    
    CGFloat animationDuration = 0.3;
    
    // Create the path for the bounces
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    
    CGFloat originalOffsetX = imageView.center.x - midX;
    CGFloat originalOffsetY = imageView.center.y - midY;
    
    BOOL stopAnimation = NO;
    
    CGPathMoveToPoint(thePath, NULL, imageView.center.x, imageView.center.y);
    float  xPosition ;
    float  yPosition ;
    float   angle = 0.0f;
    
    
    while (stopAnimation != YES) {
        
        xPosition = imageView.center.x - originalOffsetX*sin(angle*(PI/180));
        yPosition = imageView.center.y - originalOffsetY*sin(angle*(PI/180));
        CGPathAddLineToPoint(thePath, NULL, xPosition, yPosition);
        
        
        angle = angle +1.0f;   
        
        if(angle == 90.0f||angle > 90.0f)  
            stopAnimation = YES;
    }
    
    [imageView  setCenter:CGPointMake(midX,midY)];
    
    animation.path = thePath;
    CGPathRelease(thePath);
    animation.duration = animationDuration;
    
    
    // Create a basic animation
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    shrinkAnimation.removedOnCompletion = YES;
    shrinkAnimation.duration = animationDuration;
    shrinkAnimation.fromValue = [NSValue valueWithCGRect:imageView.frame];
    shrinkAnimation.byValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    shrinkAnimation.toValue = [NSValue valueWithCGRect:headImageOrgRect];
    
    
    // Create an animation group to combine the keyframe and basic animations
    CAAnimationGroup *theGroup = [CAAnimationGroup animation];
    
    // Set self as the delegate to allow for a callback to reenable user interaction
    theGroup.delegate = self;
    theGroup.duration = animationDuration;
    theGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    theGroup.animations = [NSArray arrayWithObjects:animation, shrinkAnimation, nil];
    
    
    // Add the animation group to the layer
    [TransLayer addAnimation:theGroup forKey:@"animatePlacardViewToCenter"];
    
    // Set the  view's center and transformation to the original values in preparation for the end of the animation
    
    imageView.transform = CGAffineTransformIdentity;
    [imageView   setFrame:headImageOrgRect];
    
}

@end
