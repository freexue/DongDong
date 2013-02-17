//
//  ExercisePicker.m
//  TestUI
//
//  Created by Ye Ke on 12/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "ExercisePicker.h"

@implementation ExercisePicker

-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}

+(void)updateExandParts:(NSMutableArray *)exArr{
    for (Exercise * ex in exArr) {
        [ex.part updateAfterEx];
        ex.exNum ++;
        ex.lastdoDate = [NSDate date];
        [ex saveToDecitonary];
    }
    [[UserData sharedUser] importUser];
}

+(NSMutableArray *)choosePart:(int)num {
    
    NSMutableArray * parts = [UserData sharedUser].parts;
    
    NSMutableArray * badPart = [[NSMutableArray alloc]init];
    NSMutableArray * mediumPart = [[NSMutableArray alloc]init];
    NSMutableArray * ordinaryPart = [[NSMutableArray alloc]init];
    NSMutableArray * goodPart = [[NSMutableArray alloc]init];
    
    
    //100:  0~45: Bad Part;  46~75: Medium Part; 76~90: Oridnary Part; 91~99: Good
    
    int boundary1 = 45, boundary2 = 75, boundary3 = 90;
    int e_bad, e_medium, e_ordinary, e_good;
    e_bad = e_medium = e_ordinary = e_good = 0;
    
    int SK = 100;
    
    for (int i =0; i < 2; i ++) {
        int type = arc4random()%SK;
        
        if (type < boundary1) {
            e_bad ++;
        }
        else if(type < boundary2) {
            e_medium ++;
        }
        else if(type < boundary3) {
            e_ordinary ++;
        }
        else {
            e_good ++;
        }
    }
    //Initialzing and divide different status parts;
    for (Part * pt in parts ) {
        if (pt.status == GOOD) {
            [goodPart addObject:pt];
        }else if(pt.status == COMMON) {
            [ordinaryPart addObject:pt];
        }else if(pt.status == MEDIUM) {
            [mediumPart addObject:pt];
        }else
            [badPart addObject:pt];
    }
    int needdilever = 2;
    
    NSLog(@"------------------");
    NSLog(@"Array   %d %d %d %d", badPart.count, mediumPart.count, ordinaryPart.count, goodPart.count);
    NSLog(@"Diliver %d %d %d %d", e_bad, e_medium, e_ordinary, e_good);
    
    while (needdilever > 0) {
        
        NSLog(@"needdiliver0 %d",needdilever);
        
        if(e_bad  > badPart.count){
            e_medium += e_bad - badPart.count;
            e_bad = badPart.count;
            needdilever -= badPart.count;
            
            NSLog(@"-------Bad------");
            NSLog(@"Array   %d %d %d %d", badPart.count, mediumPart.count, ordinaryPart.count, goodPart.count);
            NSLog(@"Diliver %d %d %d %d", e_bad, e_medium, e_ordinary, e_good);
            NSLog(@"needdiliver1 %d",needdilever);
        }
        else needdilever -= e_bad;
        if(e_medium  > mediumPart.count){
            e_ordinary += e_medium - mediumPart.count;
            e_medium = mediumPart.count;
            needdilever -= mediumPart.count;
            
            NSLog(@"------Medium------");
            NSLog(@"Array   %d %d %d %d", badPart.count, mediumPart.count, ordinaryPart.count, goodPart.count);
            NSLog(@"Diliver %d %d %d %d", e_bad, e_medium, e_ordinary, e_good);
            NSLog(@"needdiliver2 %d",needdilever);
        }
        else needdilever -= e_medium;
        if(e_ordinary > ordinaryPart.count) {
            e_good += e_ordinary - ordinaryPart.count;
            e_ordinary = ordinaryPart.count;
            needdilever -= ordinaryPart.count;
            
            NSLog(@"------Ordinary------");
            NSLog(@"Array   %d %d %d %d", badPart.count, mediumPart.count, ordinaryPart.count, goodPart.count);
            NSLog(@"Diliver %d %d %d %d", e_bad, e_medium, e_ordinary, e_good);
            NSLog(@"needdiliver3 %d",needdilever);
        }
        else needdilever -= e_ordinary;
        if(e_good > goodPart.count){
            e_bad += e_good - goodPart.count;
            e_good = goodPart.count;
            needdilever -= goodPart.count;
            
            NSLog(@"------Good------");
            NSLog(@"Array   %d %d %d %d", badPart.count, mediumPart.count, ordinaryPart.count, goodPart.count);
            NSLog(@"Diliver %d %d %d %d", e_bad, e_medium, e_ordinary, e_good);
            NSLog(@"needdiliver4 %d",needdilever);
        }
        else needdilever -= e_good;
    }
    
    NSMutableArray * chosenParts = [[NSMutableArray alloc]init];
    
    NSMutableArray * bds = [ExercisePicker getParts:e_bad ofLeastDoParts:badPart];
    [chosenParts addObjectsFromArray:bds];
    NSMutableArray * mds = [ExercisePicker getParts:e_medium ofLeastDoParts:mediumPart];
    [chosenParts addObjectsFromArray:mds];
    
    NSMutableArray * exs = [ExercisePicker getnumbers:e_bad + e_medium ofLeastDoExs:chosenParts];
    
    [chosenParts removeAllObjects];
    
    NSMutableArray * ods = [ExercisePicker getParts:e_ordinary ofLeastDoParts: ordinaryPart];
    [chosenParts addObjectsFromArray:ods];
    NSMutableArray * gds = [ExercisePicker getParts:e_good ofLeastDoParts: goodPart];
    [chosenParts addObjectsFromArray:gds];
 
    NSMutableArray * exs_sub = [ExercisePicker getnumbers:e_ordinary+ e_good ofLeastDoExs:chosenParts];
    
    if (!exs) {
        exs = [[NSMutableArray alloc] init] ;
    }
    
    [exs addObjectsFromArray:exs_sub];
    
    return exs;
}

+(NSMutableArray *)getParts:(int)num ofLeastDoParts:(NSMutableArray *)parts {
    if (parts.count == 0 || num == 0) {
        return nil;
    }
    else if( num >= parts.count) {
        return parts;
    }
    else {
        NSMutableArray * t_pts = [[[NSMutableArray alloc] initWithArray:parts] autorelease];
        NSMutableArray * leastDos = [[[NSMutableArray alloc]init] autorelease];
        for (int i = 0; i < num; i++) {
            Part * least = [[[Part alloc]init] autorelease];
            least.exercisedNum = 1000000;
            for (Part * pt in t_pts) {
                if ((pt.conditiontype == HURT || pt.conditiontype == POTENTIAL)&& (pt.exercisedNum == 0)){
                    least = pt;
                    break;
                }
                if(pt.exercisedNum <= least.exercisedNum)
                    least = pt;
            }
            [leastDos addObject:least];
            [t_pts removeObject:least];
            
        }
        
        return leastDos;
    }
}

+(NSMutableArray *)getnumbers:(int)num ofLeastDoExs:(NSMutableArray *)parts {
    
    if (num == 0) {
        return nil;
    }
    
    NSMutableArray * exercises = [[[NSMutableArray alloc]init] autorelease];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    
    //[ExercisePicker moveDoc];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (Part * pt in parts) {
        NSString * name = pt.name;
        [exercises addObjectsFromArray:[Exercise readFromPLIST:dictionary with: name]];
    }
    
    [dictionary release];
    
    if (num >= exercises.count ) {
        return exercises;
    }
    else {
        NSMutableArray * leastDos = [[[NSMutableArray alloc]init] autorelease];
        
        for (int i = 0; i < num; i++) {
            Exercise * least = [[[Exercise alloc]init] autorelease];
            least.exNum = 100000;
            for (Exercise * ex in exercises) {
                if(ex.exNum <= least.exNum)
                    least = ex;
            }
            [leastDos addObject:least];
            [exercises removeObject:least];
        }
        return leastDos;
    }
}


+(BOOL)updatePLIST {
    
    //Get The OldDictionary
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    NSMutableDictionary *olddictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [self moveDoc];
    
    NSMutableDictionary * newdictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (int i = 0; i < 1; i ++) {
        
        NSMutableDictionary * old_partDic = [olddictionary objectForKey:@"head"];
        NSMutableArray * old_exItems = [old_partDic objectForKey:@"Items"];
        
        NSArray * partArr = @[@"head",@"neck",@"shoulder",@"waist",@"back",@"leg",@"butt",@"wrist"];
        
        for (NSString * partName in partArr) {
            NSMutableDictionary * partDic = [newdictionary objectForKey:partName];
            NSMutableArray * exItems = [partDic objectForKey:@"Items"];
            
            for (int i =0; i < [exItems count]; i++) {
                
                NSMutableDictionary * old_exItem = [old_exItems objectAtIndex:i];

                NSNumber * exNumber = [old_exItem objectForKey:@"ExNum"];

                NSString * exString = [old_exItem objectForKey:@"LastDt"];
                
                NSMutableDictionary * exItem = [exItems objectAtIndex:i];
                [exItem setObject:exNumber forKey:@"ExNum"];
                [exItem setObject:exString forKey:@"LastDt"];
                [exItems replaceObjectAtIndex:i withObject:exItem];
                [partDic setObject:exItems forKey:@"Items"];
                [newdictionary setObject:partDic forKey:partName];
                
                break;
                }
            }   

        }
        
        
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    
    NSLog(@"String: %@", writableDBPath);
    if([newdictionary writeToFile:writableDBPath atomically:YES ])
        NSLog(@"YES----------------------");
    else
        NSLog(@"NO-----------------------");
    return YES;
}

+(BOOL)moveDoc {
    
    BOOL success;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"Action(3).plist"];
    NSError* error=nil;
    
    if([fileManager fileExistsAtPath:writableDBPath]){
        NSLog(@"-FileExists!");
    }
    else {
        NSLog(@"-FileDontExist");
    }
    if([fileManager fileExistsAtPath:writableDBPath])
        if (![fileManager removeItemAtPath:writableDBPath error:&error])
    {
        NSLog(@"Could not remove old files. Error:%@",error);
        [error release];
    }
    if([fileManager fileExistsAtPath:writableDBPath]){
        NSLog(@"FileExists!");
    }
    else {
        NSLog(@"FileDontExist");
    }
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Action(3).plist"];
    
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (error!=nil) {
        NSLog(@"%@", error);
        NSLog(@"%@", [error userInfo]);
    }
    return success;
}

+(BOOL)is:(NSDate * )dt1 MoreRecnetThan:(NSDate *)dt2 {
    return [dt1 timeIntervalSinceDate:dt2] > 0;
}

/**
 Only 2 Exercises are needed. 
 */
+(NSMutableArray *)setParts {   // 4 2 1 Parts Choose
    
    /*
     @"head",
     @"neck",
     @"shoulder",
     @"wrist",
     @"back",
     @"waist",
     @"butt",
     @"leg"
     */
    
    NSArray * pArr = [NSArray arrayWithObjects:
                      @"head",
                      @"neck",
                      @"back",
                      @"shoulder",
                      @"wrist",
                      @"waist",
                      @"elbow",
                      @"butt",
                      @"leg",
                      @"finger",
                      nil];
    
    Data* data = [[Data alloc]init];
    int n1,n2,n3;  //n1: Ticked  n2: Potential n3: None
    n1 = n2 = n3 = 0;
    
    NSMutableArray * ticked = [[NSMutableArray alloc]init];
    NSMutableArray * poten = [[NSMutableArray alloc]init];
    NSMutableArray * no = [[NSMutableArray alloc]init];
    
    
    for (int i=0; i<[pArr count]; i++) {
        NSString * part = [pArr objectAtIndex:i];
        int cate = [[UserData sharedUser] getPart:part]; //cate 0: Not Related 1:Ticked As Related Part 2:Potential
        
        if (cate == 0)
        {
            [no addObject:part];
            n3++;
        }
        else if(cate == 1)
        {
            [ticked addObject:part];
            n1++;
        }
        else if(cate == 2)
        {
            [poten addObject:part];
            n2++;
        }
    }
    
    //ticked: {@"head",@"neck"}
    
    NSArray * noInfo = [ExercisePicker loadInfo:no];
    NSArray * potenInfo = [ExercisePicker loadInfo:poten];
    NSArray * tickInfo = [ExercisePicker loadInfo:ticked];
    
    NSLog(@"n1 : %d n2 %d n3 %d", n1, n2, n3);
    
    
    //Change: The Sum has Changed
    int sum = 10;//5*n1 + 2*n2 + n3;
    
    int i1 = 0;
    int i2 = 4 ;
    int i3 = 7;
    
    int e1, e2, e3;
    e1 = e2 = e3 = 0; // Number of Excercises
    
    for (int i=0; i<4; i++) {  //Change: The number of exs, from 4 to 2
        int flag = arc4random()%sum + 1;
        if (flag > i1 && flag <= i2) {
            e1 ++ ;
        }
        else if(flag > i2 && flag <= i3){
            e2 ++ ;
        }
        else if(flag > i3) {
            e3 ++ ;
        }
    }
    
    Boolean notfinished = YES;
    NSLog(@"Original E1 %d E2 %d E3 %d", e1, e2, e3);
    
    while (notfinished) {
        if (e1  > [tickInfo count]) {
            e1 -- ;
            e2 ++ ;
        }
        else if(e2 > [potenInfo count]){
            e2 --;
            e3 ++;
        }
        else if(e3 > [noInfo count]){
            e3 --;
            e1 ++;
        }
        
        if (e1 <= [tickInfo count] && e2 <= [potenInfo count] && e3 <= [noInfo count]) {
            notfinished = NO;  //OK
        }
    }
    
    
    NSLog(@"E1 %d E2 %d E3 %d", e1, e2, e3);
    NSMutableArray * part1 = nil;
    NSMutableArray * part2 = nil;
    NSMutableArray * part3 = nil;
    
    for (int i=0; i< [tickInfo count]; i++) {
        NSDictionary * dic_score = [tickInfo objectAtIndex:i];
        NSString * pstr = [dic_score objectForKey:@"Name"];
        NSString * cateGory = [dic_score objectForKey:@"Category"];
        NSLog(@"%@ %@", pstr, cateGory);
    }
    
    NSLog(@"TickInfo %d", [tickInfo count]);
    NSLog(@"PotenInfo %d", [potenInfo count]);
    NSLog(@"NoInfo %d", [noInfo count]);
    
    //tickInfo: {
    //       dictionary:{
    //           name: Neck1
    //           category: neck
    //          }
    //           }
    
    //Very Bad Code Below////////////////////////////////////////
    
    if ([tickInfo count] >= e1 && e1!=0 ) {
        part1 = [data leastdo:tickInfo num:e1];
    }
    else if(e1 == 0){
        e3 += e1;
    }
    else if([tickInfo count] !=0){
        part1 = [data leastdo:tickInfo num:[tickInfo count]];
        e3 += e1 - [tickInfo count];
    }
    else {
        e3 += e1;
    }
    
    if ([potenInfo count] >= e2 && e2!=0 ) {
        part2 = [data leastdo:potenInfo num:e2];
    }
    else if(e2 == 0){
        e3 += e2;
    }
    else if([potenInfo count] !=0){
        part2 = [data leastdo:tickInfo num:[potenInfo count]];
        e3 += e2 - [potenInfo count];
    }
    else
    {
        e3 += e2;
    }
    //FIND LEAST IN Exercise Array
    ////////////////////////////////////////////////////////////////
    
    NSLog(@"After E1 %d E2 %d E3 %d", e1, e2, e3);
    
    if (e3 != 0) {
        part3 = [data leastdo:noInfo num:e3];
    }
    
    NSMutableArray * orders = [[NSMutableArray alloc]init];
    [orders addObjectsFromArray: part1];
    [orders addObjectsFromArray: part2];
    [orders addObjectsFromArray: part3];
    
    [ExercisePicker PrintArr:orders and:@"ORDER_ORIGIN"];
    
    //Change Orders of Head and Butt
    orders = [ExercisePicker changeOrder:orders with:0];
    orders = [ExercisePicker changeOrder:orders with:1];
    [ExercisePicker updateOrder:orders with: part1];
    
    //Put head first, butt last
    
    NSLog(@"Part %d %d %d", [part1 count], [part2 count], [part3 count]);
    
    [ExercisePicker PrintArr:orders and:@"ORDER"];
    return orders;
}

+(void)PrintArr:(NSArray *)arr and:(NSString *)name {
    NSLog(@"-----------%@------------", name);
    if (arr == nil) {
        NSLog(@"non-decleared arr");
        
    }
    else {
        for (int i =0; i<[arr count]; i++) {
            NSString * str = [arr objectAtIndex:i];
            NSLog(@"Element %d : %@",i, str);
        }
    }
}

+(void)searchForFiles:(NSArray *)orders {
    
    for (int i=0; i<[orders count]; i++) {
        NSString * excercise = [orders objectAtIndex:i];
        [excercise substringToIndex:0];
    }
}

+(NSMutableArray *)updateOrder:(NSMutableArray* )orders with: (NSMutableArray *)array {
    
    NSString * mainP;
    
    for (int j = 0 ; j < [array count]; j ++) {
        mainP = [array objectAtIndex:j];
        
        for (int i = 0; i<[orders count]; i++) {
            NSString * part = [orders objectAtIndex:i];
            NSRange range = [part rangeOfString:mainP];
            
            int head_n = 0;
            if (range.length > 0) {  //The part is in Head or Butt
                NSString * tpart = [NSString string];
                for (int j = 0; j<[orders count]; j++) {
                    tpart = [orders objectAtIndex:head_n];
                    NSRange  tr = [tpart rangeOfString:mainP];
                    if (tr.length > 0 && i!=head_n) {
                        head_n ++;
                    }
                    else {
                        break;
                    }
                }
                [orders replaceObjectAtIndex:head_n withObject:part];
                [orders replaceObjectAtIndex:i withObject:tpart];
            }
        }
        
    }
    return orders;
}

+(NSMutableArray *)changeOrder:(NSMutableArray* )orders with:(int)type {
    
    NSString * mainP;
    if (type == 0) {
        mainP = @"HEAD";
    }
    else {
        mainP = @"BUTT";
    }
    for (int i = 0; i<[orders count]; i++) {
        NSString * part = [orders objectAtIndex:i];
        NSRange range = [part rangeOfString:mainP];
        
        int head_n = (type>0)? [orders count] - 1:0;
        if (range.length > 0) {  //The part is in Head or Butt
            NSString * tpart = [NSString string];
            for (int j = 0; j<[orders count]; j++) {
                tpart = [orders objectAtIndex:head_n];
                NSRange  tr = [tpart rangeOfString:mainP];
                if (tr.length > 0 && i!=head_n) {
                    if (type == 0) {
                        head_n ++;
                    }
                    else {
                        head_n -- ;
                    }
                }
                else {
                    break;
                }
            }
            [orders replaceObjectAtIndex:head_n withObject:part];
            [orders replaceObjectAtIndex:i withObject:tpart];
        }
    }
    return orders;
}


+(NSArray *)loadInfo:(NSMutableArray *)pArr {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RIndex" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    NSArray * excercises = [dictionary objectForKey:@"Arr"];
    
    NSMutableArray * info = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[excercises count]; i++) {
        
        NSDictionary * ex = [excercises objectAtIndex:i];
        NSString * exName = [ex objectForKey:@"Name"];
        NSString * exCate = [ex objectForKey:@"Category"];
        
        for (int j=0; j< [pArr count]; j++) {
            
            NSString * part = [pArr objectAtIndex:j];
            
            if ([exCate isEqualToString:part]) {
                
                NSLog(@"Find Name %@", exName);
                
                NSDictionary * dic_score = [[NSDictionary alloc]initWithObjectsAndKeys:exName,@"Name",exCate,@"Category",nil];
                [info addObject:dic_score];
                [dic_score release];
                //Name : Category Changes
            }
        }
    }
    return [info autorelease];   //Name: xx Category: xx
}

/**
 lastStep
 */
+(NSArray *)extractFromActionPlist:(NSArray *)exerciseOrders {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Action" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    NSMutableArray * rawData = [[[NSMutableArray alloc]init] autorelease];
    
    //Only For Exercises Choosed
    
    for (int i =0; i < [exerciseOrders count]; i++) {
        NSString * str = [exerciseOrders objectAtIndex:i];
        str = [str lowercaseString];
        
        NSString * part = [[UserData sharedUser] getPartName: str];
        part = [part capitalizedString];
        
        //According To PartName, Fetch All Items From Action.plist
        NSDictionary * dic = [dictionary objectForKey:part];
        NSArray * exs = [dic objectForKey:@"Items"];
        
        //Find Equal Names of Exercises In Items Array
        for (int j=0; j<[exs count]; j++) {
            NSDictionary * dic2 = [exs objectAtIndex:j];
            NSString * str2 = [dic2 objectForKey:@"File"];
            if ([str2 isEqualToString:str]) {
                NSLog(@"Exs : %@", str2);
                [rawData addObject:dic2];  //Make RawData Get Exercises Info
            }
        }
    }
    
    return rawData;
}




@end
