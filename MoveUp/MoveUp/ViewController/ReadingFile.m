//
//  ReadingFile.m
//  TestUI
//
//  Created by Ke Ye on 8/10/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "ReadingFile.h"
#import "UserData.h"

@implementation ReadingFile
@synthesize category;
@synthesize name;
@synthesize file;
@synthesize img;
@synthesize img2;
@synthesize time;
@synthesize imgNum;
@synthesize content;
@synthesize switchTime;
@synthesize tips;

-(id)initWith:(NSDictionary *)dict{
    
    if ([super init]) {
       imgNum = [(NSNumber *)[dict objectForKey:@"ImageNum"] intValue];
       time = [(NSNumber *)[dict objectForKey:@"Time"] intValue];
        
        int gender = [UserData sharedUser].gender;
        
        if (![SystemConfig isIphone5])
            img = [NSString stringWithFormat:@"%d%@",gender,[dict objectForKey:@"Image"]];
        else{
            NSString * imgStr = [dict objectForKey:@"Image"];
            imgStr = [imgStr substringToIndex:imgStr.length - 4];
            img = [NSString stringWithFormat:@"%d%@-568.png",gender,imgStr];
        }
        
        [img retain];
        
        NSLog(@"Img %@", img);
        
        if (imgNum > 1) {
             img2 = [NSString stringWithFormat:@"%d%@",gender,[dict objectForKey:@"Image2"]];
        }
       
        if ([dict objectForKey:@"SwitchTime"] != nil) {
            switchTime = [ [dict objectForKey:@"SwitchTime"]intValue];
        }
        else
        switchTime = 1000;  //Maximum it 
        
        [img2 retain];
        name = [dict objectForKey:@"Name"];
        category = [dict objectForKey:@"Category"];
        file = [dict objectForKey:@"File"];
        content = [dict objectForKey:@"Content"];
        tips = [dict objectForKey:@"Tip"];
        if (tips == nil) {
            tips = @"0";
        }
        
    }
    return self;
}

@end
