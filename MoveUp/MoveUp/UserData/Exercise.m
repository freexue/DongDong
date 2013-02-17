//
//  Exercise.m
//  TestUI
//
//  Created by Ye Ke on 1/10/13.
//  Copyright (c) 2013 New Success. All rights reserved.
//

#import "Exercise.h"
#import "Behavior.h"

@implementation Exercise

@synthesize hasIndication;
@synthesize i_Description;
@synthesize i_ImagePath;
@synthesize videoPath;
@synthesize startSec;
@synthesize exNum;
@synthesize part;
@synthesize lastdoDate;
@synthesize exName;
@synthesize i_SoundPath;
@synthesize content;
@synthesize title;

-(id)init{
    if (self = [super init]) {
        i_Description = @"";
        i_ImagePath = @"";
        i_SoundPath = @"";
        content = @"";
        title = @"";
        exName = @"";
        part = nil;
        lastdoDate = [NSDate distantPast];
    }
    return self;
}

-(NSMutableDictionary *)saveToDecitonary {
    /*
    if([self moveDoc])
        NSLog(@"Copied Safely");
    else
        NSLog(@"No!!!!!!!!!!!");
    */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSMutableDictionary * partDic = [dictionary objectForKey:part.name];
    NSMutableArray * exItems = [partDic objectForKey:@"Items"];
    for (int i =0; i < [exItems count]; i++) {
        NSMutableDictionary * exItem = [exItems objectAtIndex:i];
        if([self.exName isEqualToString: [exItem objectForKey:@"File"] ]){
            [exItem setObject:[NSNumber numberWithInt:self.exNum] forKey:@"ExNum"];
            [exItem setObject:ToString(self.lastdoDate) forKey:@"LastDt"];
            [exItems replaceObjectAtIndex:i withObject:exItem];
            [partDic setObject:exItems forKey:@"Items"];
            [dictionary setObject:partDic forKey:part.name];
            break;
        }
    }
    
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    
    NSLog(@"String: %@", writableDBPath);
    if([dictionary writeToFile:writableDBPath atomically:YES ])
        NSLog(@"YES----------------------");
    else
        NSLog(@"NO-----------------------");
    return log;
}

-(BOOL)moveDoc {
    BOOL success;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    //if (success) return success;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Action(3).plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:nil];
    return success;
}

-(void)loadFromDictionary:(NSMutableDictionary *)tlog {
    
    self.exName =  [tlog objectForKey:@"File"];
    self.videoPath = self.exName;
    
    self.part =   [Part getPart:[tlog objectForKey:@"Category"]];
    self.content = [tlog objectForKey:@"Content"];
    self.title = [tlog objectForKey:@"Name"];
    self.exNum = [[tlog objectForKey:@"ExNum"] intValue];
    
    
    NSString * lsdtStr = [tlog objectForKey:@"lastDt"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dt = [formatter dateFromString:lsdtStr];
    if (!dt) {
        self.lastdoDate = [[NSDate distantPast] retain];
    }else {
        self.lastdoDate = dt;
    }

    self.hasIndication = ([[tlog objectForKey:@"hasIndication"] intValue] == 1) ;
    
    if (self.hasIndication) {
        self.i_Description = [tlog objectForKey:@"i_Description"];
        self.i_ImagePath = [tlog objectForKey:@"i_ImagePath"];
        self.i_SoundPath = [tlog objectForKey:@"i_SoundPath"];
        self.startSec = [[tlog objectForKey:@"startSec"] floatValue];
    }
    
    log = tlog;
}

+(NSMutableArray *)readFromPLIST:(NSDictionary *)info with:(NSString *)partName {
    
    NSMutableArray * exs = [[NSMutableArray alloc]init];

    NSDictionary * partDic = [info objectForKey: partName];
    NSArray * exItems = [partDic objectForKey:@"Items"];
    
    for (int i =0; i< [exItems count]; i++) {
            NSMutableDictionary * exItem =  [exItems objectAtIndex:i];
            Exercise * ex = [[Exercise alloc]init];
            [ex loadFromDictionary:exItem];
            [exs addObject:ex];
    }
    return exs;
}

-(void)printInfo {
    
    NSLog(@"\n<========EXERCISE========>");
    
    NSLog(@"ExName: %@", exName);
    NSLog(@"Title  %@", title);
    NSLog(@"Content %@", content);
    NSLog(@"LastDate %@", lastdoDate);
    NSLog(@"VideoPath %@", videoPath);
    NSLog(@"HasIndication %d", hasIndication);
    NSLog(@"exNum %d",exNum);
    NSLog(@"PART:---------------------------");
    if (part) 
        [part printInfo];
    else
        NSLog(@"No Part Attached!");
        
    if (hasIndication) {
        
        NSLog(@"Description %@", i_Description);
        NSLog(@"ImagePath %@", i_ImagePath);
        NSLog(@"SoundPath %@", i_SoundPath);
        NSLog(@"Sec %f", startSec);
    }
}


@end
