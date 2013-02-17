//
//  UserData.m
//  TestUI
//
//  Created by Ke Ye on 8/8/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "UserData.h"
#import "Data.h"



static UserData * usr;
@implementation UserData
@synthesize achievements;
@synthesize neck;
@synthesize back;
@synthesize waist;
@synthesize finger;
@synthesize wrist;
@synthesize elbow;
@synthesize butt;
@synthesize leg;
@synthesize head;
@synthesize shoulder;

@synthesize gender;
@synthesize noti1Time;
@synthesize noti2Time;

@synthesize sittingTime;
@synthesize compTime;
@synthesize medal;

@synthesize prohibit;
@synthesize insistDays;
@synthesize insistWeeks;
@synthesize lastdt;

@synthesize behaviors;
@synthesize parts;
@synthesize sympthons;
@synthesize ID;
@synthesize age;
@synthesize sympthonFactor;
@synthesize regstrTime;
@synthesize weiboName;
@synthesize notiArr;
@synthesize notiFactor;
@synthesize fitRate;
@synthesize exDaysNum;
@synthesize quizData;
@synthesize weekDays;
@synthesize progress;
@synthesize exercises;
@synthesize lastFinishDt;
@synthesize startStatus;
@synthesize token; //Need to store it? Or not?

+(UserData *)sharedUser { 
    if (usr == nil) {   
        usr = [[UserData alloc]init];  
    }  
    return usr;
} 

-(void)resetUser {
    usr = nil;
    usr = [[UserData alloc] init];
}

-(id)init {
    
    if (self = [super init]) {
        medal=0;
        self.achievements = [[NSMutableArray alloc] initWithCapacity:8];
        
        for (int i=0; i<8; i++) {
            [self.achievements addObject:[NSNumber numberWithInt:0]];
        }
        
        //如果没有以下信息，再次调用[[UserData sharedUser]init]信息没有初始化
        NSDate * dt = [[NSDate alloc] init];
        self.lastdt = dt;
        self.lastFinishDt = [NSDate distantPast];
        [dt release];  //Modified Here
        
        [self createID];
         
         neck=0;
         back=0;
         waist=0;
         finger=0;
         wrist=0;
         elbow=0;
         butt=0;
         leg=0;
         head=0;
         shoulder=0;
        
         // --------- Parts ---------
        
         sittingTime=2;
         compTime=2;
         prohibit = 5;
         insistDays = 0;
         insistWeeks = 0;
         startStatus = FROMSTART;
        
        // --------- New Info ---------
        
        //Meaningless Initalization, for Default Only
        //sympthons -> parts
        
        parts = [[NSMutableArray alloc] init];    
        behaviors = [[NSMutableArray alloc] init]; 
        sympthons = [[NSMutableArray alloc] init];
        quizData = [[NSMutableArray alloc]init];
        weekDays = [[NSMutableArray alloc]init];
        notiArr = [[NSMutableArray alloc]init];
        exercises = [[NSMutableArray alloc]init];
        
        age = 0;
        exDaysNum = 0;
        fitRate = 0;
        progress = 0;
        sympthonFactor = 0;
        
        for(int i = 0; i < 10; i++) {
            [quizData addObject:[NSNumber numberWithInt:0]];
        }
        for(int i = 0; i < 7; i++) {
            [weekDays addObject:[NSNumber numberWithInt:1]];  //1 Means Choosen
        }

        [notiArr addObject:[NSNumber numberWithInt:1100]];
        [notiArr addObject:[NSNumber numberWithInt:1600]];
    }
    return self;
}

#pragma mark IDinfo Management
-(void)createID {
   NSString * uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoveUpID"];
    
    if (!uuid) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        uuid = (NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef);
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"MoveUpID"];
        CFRelease(uuidRef);
    }
    
    self.ID = uuid;
    [self registerTime];
}

-(void)registerTime {
    
    NSDate * date = (NSDate *)
    [[NSUserDefaults standardUserDefaults] objectForKey:@"RegstrTime"];
    
    if (!date) {
        date = [[NSDate date] dateByAddingTimeInterval: 60 * 60 * 8];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"RegstrTime"];
    }
    self.regstrTime = date;
}

-(Boolean)checkID {
    NSString * uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"MoveUpID"];
    if (uuid) {
        return YES;
    }
    return NO;
}

#pragma mark BehaviorMethods
-(void)importBehaviors {
    
    NSMutableArray * logs  = [[NSMutableArray alloc]init];
    for (Behavior * bh in behaviors) {
       NSMutableDictionary * dic = [bh saveToDecitonary];
        [logs addObject:dic];
    }
    //NOTE: NEED TO ADD LIMITATIONS
    [[NSUserDefaults standardUserDefaults] setObject:logs forKey:@"behaviors"];
    [logs release];
}


-(NSMutableArray *)exportBehaviors {
    
    //Array Of Log Dictionary -> Bahavior Class Array
    NSMutableArray * behavior_log  = [[NSUserDefaults standardUserDefaults] objectForKey:@"behaviors"];
    
    if (behavior_log == nil) {
        return [[[NSMutableArray alloc]init] autorelease];
    }
    
    NSMutableArray * t_behaviors = [[NSMutableArray alloc]init];
    
    for ( NSMutableDictionary * dic in  behavior_log ) {
        Behavior * bh = [[[Behavior alloc] init] autorelease];
        bh = [bh loadFromDictionary:dic];
        [bh printInfo];
        [t_behaviors addObject:bh];
        
    }
    return [t_behaviors autorelease];
}

#pragma mark PartMethods

-(void)importParts {
    NSMutableArray * logs  = [[NSMutableArray alloc]init];
    for (Part * pt in parts) {
        NSMutableDictionary * dic = [pt saveToDecitonary];
        [logs addObject:dic];
    }
    //NOTE: NEED TO ADD LIMITATIONS
    [[NSUserDefaults standardUserDefaults] setObject:logs forKey:@"parts"];
    [logs release];
}

-(NSMutableArray *)exportParts {
    NSMutableArray * parts_log  = [[NSUserDefaults standardUserDefaults] objectForKey:@"parts"];
    
    if (parts_log == nil) {
        return [[[NSMutableArray alloc]init] autorelease];
    }
    
    NSMutableArray * t_parts = [[NSMutableArray alloc]init];
    
    for ( NSMutableDictionary * dic in  parts_log ) {
        
        Part * pt = [[[Part alloc]init] autorelease];
        pt = [pt loadFromDictionary:dic];
        [pt printInfo];
        [t_parts addObject:pt];
    }
    return [t_parts autorelease];
}

#pragma mark SympthonMethods 
/*
   Sympthons Format: Number of Questions, different digits as different levels
*/

-(void)importSympthons {
    
    NSMutableArray * symp_levels = [[[NSMutableArray alloc] init] autorelease];
    for (Sympthon * sym in sympthons) {
        [symp_levels addObject:[NSNumber numberWithInt:sym.level]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:symp_levels forKey:@"sympthons"];
}


-(NSMutableArray *)exportSympthons {
    NSMutableArray * syms = [[NSMutableArray alloc] init];
    NSMutableArray * levels = [[NSUserDefaults standardUserDefaults] objectForKey:@"sympthons"];
    for (NSNumber * level in levels) {
        Sympthon * sym = [[[Sympthon alloc] init] autorelease];
        sym.level = [level intValue];
        [syms addObject:sym];
    }
    return [syms autorelease];
}

-(void) setPartsFrom:(NSMutableArray *)symp {
    
}

#pragma mark Import/Export UserData


/**
 importUser: Synchronize user ; to system.
 */
-(void)importUser{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:lastdt forKey:@"date"];
    [defaults setObject:lastFinishDt forKey:@"lastfinishdate"];
    [defaults setInteger:insistDays forKey:@"insistdays"];
    [defaults setInteger:insistWeeks forKey:@"insistweeks"];
    
    [defaults setInteger:neck forKey:@"neck"];
    [defaults setInteger:back forKey:@"back"];
    [defaults setInteger:head forKey:@"head"];
    [defaults setInteger:waist forKey:@"waist"];
    [defaults setInteger:shoulder forKey:@"shoulder"];
    [defaults setInteger:leg forKey:@"leg"];
    [defaults setInteger:butt forKey:@"butt"];
    [defaults setInteger:finger forKey:@"finger"];
    [defaults setInteger:butt forKey:@"butt"];
    [defaults setInteger:wrist forKey:@"wrist"];
    [defaults setInteger:elbow forKey:@"elbow"];
    
    [defaults setBool:gender forKey:@"gender"];
    [defaults setObject:noti1Time forKey:@"noti1"];
    [defaults setObject:noti2Time forKey:@"noti2"];
    [defaults setInteger:sittingTime forKey:@"sittingTime"];
    [defaults setInteger:compTime forKey:@"compTime"];
    [defaults setInteger:prohibit forKey:@"prohibit"];
    
    [defaults setObject:achievements forKey:@"achievenments"];
    
    //New: Prime Type
    [defaults setFloat:progress forKey:@"progress"];
    
    //New: Complicated Type
    //[self importBehaviors];
    [self importParts];
    [self importSympthons];
    
    //New TEST
    [defaults setInteger:sympthonFactor forKey:@"SymFac"];
    [defaults setInteger:notiFactor forKey:@"NotiFac"];
    [defaults setObject:notiArr forKey:@"notiArr"];
    [defaults setFloat:fitRate forKey:@"fitRate"];
    [defaults setInteger:exDaysNum forKey:@"exDaysNum"];
    [defaults setObject:quizData forKey:@"quizData"];
    [defaults setObject:weekDays forKey:@"weekDays"];
    [defaults setInteger:age forKey:@"age"];
    [defaults setObject:exercises forKey:@"exercises"];

    [defaults synchronize];
}

/**
 exprotUser: Load current user information from UserDefaults.
 NOTE: When app is updated, all info from UserDefaults will check validality first.
*/
-(void)exportUser {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if (usr == nil) {    //userinfo is not initialized
        self = [[[UserData alloc]init] autorelease];
    }  
    
    compTime = [defaults integerForKey:@"compTime"];
    sittingTime = [defaults integerForKey:@"sittingTime"];
    
    insistDays = [defaults integerForKey:@"insistdays"];
    insistWeeks = [defaults integerForKey:@"insistweeks"];
    
    gender = [defaults boolForKey:@"gender"];
    noti1Time = [defaults objectForKey:@"noti1"];
    noti2Time = [defaults objectForKey:@"noti2"];
    
    elbow = [defaults integerForKey:@"elbow"];
    wrist = [defaults integerForKey:@"wrist"];
    butt = [defaults integerForKey:@"butt"];
    finger = [defaults integerForKey:@"finger"];
    neck = [defaults integerForKey:@"neck"];
    back = [defaults integerForKey:@"back"];
    head = [defaults integerForKey:@"head"];
    shoulder = [defaults integerForKey:@"shoulder"];
    leg = [defaults integerForKey:@"leg"];
    waist = [defaults integerForKey:@"waist"];
    quizData = [defaults objectForKey:@"quizData"];
    notiArr = [defaults objectForKey:@"notiArr"];
    exercises = [defaults objectForKey:@"exercises"];
    
    if (exercises) {
        exercises = [[NSMutableArray alloc]init];
    }
    
    if (!quizData) {
        quizData = [[NSMutableArray alloc]init];
        for(int i = 0; i < 10; i++) {
            [quizData addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    weekDays = [defaults objectForKey:@"weekDays"];
    if (!weekDays) {
        weekDays = [[NSMutableArray alloc]init];
        for(int i = 0; i < 7; i++) {
            [weekDays addObject:[NSNumber numberWithInt:1]];
        }
    }
    
    if (!notiArr) {
        notiArr = [[NSMutableArray alloc]init];
        [notiArr addObject:[NSNumber numberWithInt:1100]];
        [notiArr addObject:[NSNumber numberWithInt:1600]];
    }
    
    self.achievements = (NSMutableArray *)[defaults objectForKey:@"achievenments"];
    
    if(!self.achievements)
    {
        
        self.achievements = [[NSMutableArray alloc] initWithCapacity:8];
        for (int i=0; i<8; i++) {
            [self.achievements addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    prohibit = [defaults integerForKey:@"prohibit"];
    
    self.lastdt = [defaults objectForKey:@"date"];
    if (self.lastdt == nil) {
        self.lastdt = [[[NSDate alloc]init] autorelease];
    }
    
    self.lastFinishDt = [defaults objectForKey:@"lastfinishdate"];
    if (self.lastFinishDt == nil) {
        self.lastFinishDt= [NSDate distantPast];
    }
    
    //------------------New Type----------------
    self.behaviors = [self exportBehaviors];
    self.parts = [self exportParts];
    self.sympthons = [self exportSympthons];
    
    progress = [[defaults objectForKey:@"progress"] floatValue];
    
    sympthonFactor = [defaults integerForKey:@"SymFac"];
    notiFactor = [defaults integerForKey:@"NotiFac"];
    fitRate = [defaults floatForKey:@"fitRate"];
    exDaysNum = [defaults integerForKey:@"exDaysNum"];
    age = [defaults integerForKey:@"age"];
    

}



-(int)getPart:(NSString *)part {
    
    if ([part isEqualToString:@"head"]) {
        return head;
    }
    else if ([part isEqualToString:@"shoulder"]) {
        return shoulder;
    }
    else if ([part isEqualToString:@"leg"]){
        return leg;
    }
    else if ([part isEqualToString:@"waist"]){
        return waist;
    }
    else if ([part isEqualToString:@"elbow"]){
        return elbow;
    }
    else if ([part isEqualToString:@"wrist"]){
        return wrist;
    }
    else if ([part isEqualToString:@"butt"]){
        return butt;
    }
    else if([part isEqualToString:@"finger"]){
        return finger;
    }
    else if ([part isEqualToString:@"neck"]){
        return neck;
    }
    else { 
        return back;
    }
}

-(void)setPart:(NSString *)part with:(int)value {

    if ([part isEqualToString:@"head"]) {
        head = value;
    }
    else if ([part isEqualToString:@"shoulder"]) {
        shoulder = value;
    }
    else if ([part isEqualToString:@"leg"]){
        leg = value;
    }
    else if ([part isEqualToString:@"waist"]){
        waist = value;
    }
    else if ([part isEqualToString:@"elbow"]){
        elbow = value;
    }
    else if ([part isEqualToString:@"wrist"]){
        wrist = value;
    }
    else if ([part isEqualToString:@"butt"]){
        butt = value;
    }
    else if([part isEqualToString:@"finger"]){
        finger = value;
    }
    else if ([part isEqualToString:@"neck"]){
        neck = value;
    }
    else if ([part isEqualToString:@"back"]) { //if ([part isEqualToString:@"butt"])
        back = value;
    }
}


/**
 printPersonalInfo: Mainly The User Ticked Part and calculated Potential Part
*/
-(void)printPersonalInfo {
    

}

/**
 SetPotentials:Set Potential Parts According To Ticked Parts and Other Conditions
 */
-(void)setPotentials {
       
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Parts" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
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
    
    for (int i=0; i< [pArr count]; i++) {
        NSDictionary * dic = [dictionary objectForKey:[pArr objectAtIndex:i]];
        
        NSString * part = [pArr objectAtIndex:i];
        int sit = [(NSNumber *)[dic objectForKey:@"sitting"] intValue];
        int comp = [(NSNumber *)[dic objectForKey:@"comp"] intValue];
        
        if (sittingTime  >= sit||compTime >= comp ) {
            
            if ([self getPart:part]!=1) {
                [self setPart:part with:2];
            }
        }
    }
    
    for (int i=0; i < [pArr count]; i++) {
        NSString * part = [pArr objectAtIndex:i];
        
        if ([[UserData sharedUser] getPart:part]==1)
        {
            NSLog(@"Part: %@------------------------------", part);
            NSDictionary * maindic = [dictionary objectForKey:part];
            int cate = [[maindic objectForKey:@"cluster"] intValue];
            for(int j=0; j<[pArr count]; j++)
            {
                NSString * part2 = [pArr objectAtIndex:j];
                NSDictionary * dic = [dictionary objectForKey:part2];
                int cate2 = [[dic objectForKey:@"cluster"] intValue];
                if((cate == cate2) && cate!=0 && (![part isEqualToString:part2]))
                {
                    if ([self getPart:part2]!=1)
                        [self setPart:part2 with:2];
                }
            }
        }
    }
    
    [dictionary release];
}

/**
 getPartName: get exercise name, then fetch the part it is working on.RIndex is a riversed-index for exercise - part. 
 */
-(NSString *)getPartName:(NSString *)exercise {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"RIndex" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSArray * excercises = [dictionary objectForKey:@"Arr"];
    
    for (int i=0; i<[excercises count]; i++) {
        NSDictionary * dic = [excercises objectAtIndex:i];
        NSString * name = [dic objectForKey:@"Name"];
        if ([name isEqualToString:exercise]) {
            return [dic objectForKey:@"Category"];
        }
    }
    return nil;
}

/**
 updateInsisteDate: Update insist date, 
 */
-(void)updateInsistDate {
        
    NSDate * nowdt = [[NSDate alloc]init];
    
    int result = [self dayDifference:lastdt to:nowdt]; //Find the day difference between lastDate and currentDate
    
    if (result == 2) { //If 2, plus day, or even plus a week.
        insistDays ++;

        if (insistDays  == prohibit) {
            insistDays = 1;
            insistWeeks ++ ;
        }
         self.lastdt = nowdt;
    }
    else if (result == 0){ //If 1, recount from 0.
        
        insistDays = 1;
        insistWeeks = 0;
        self.lastdt = nowdt;
    }
    else {                 //If 2, means user has done it.
        self.lastdt = nowdt;
    }
    [nowdt release];
}


-(void)updateExDaysNum {
    
    int days = [[UserConfig config] dayDifference:lastFinishDt to:[NSDate date]];
    
    if (days == 0) {
        lastFinishDt = [NSDate new];
        startStatus = NORMAL;
    }else {
        lastFinishDt = [NSDate new];
        exDaysNum ++;
        startStatus = JUSTADDED;
    }
}

/**
 UpdateFitrate
 Curve Exp: -100.0 / ( 10.0 + Progress ) + 10.0;
 Progress:( Init_Progress ~ Infenity)
 Every Ex Will Adding the Progress (Equaly) 1
 Every Blank Day Will Reduce the Progress (Equaly) 0.3
 */
-(void)updateFitRate {
    
    int days = [[UserConfig config] dayDifference:lastdt to:[[NSDate new] autorelease]];
    
    NSLog(@"date1: %@  date2 %@ days %d", lastdt, [[NSDate new] autorelease], days);
    
    self.progress -= days * ((100 - fitRate)/125);
    lastdt = [NSDate new];
    
    float rate =  -100.0/( progress + 10.0 ) + 10.0;
    fitRate = rate * 10;
    
    NSLog(@"progress: %f   fitrate: %f", progress, fitRate);
}

-(void)addProgress {
    progress += 1.0;
}

/**
  isWinningAchievement: choose others to 
  return -1: means nothing
  return others: means achieve sth.
 */
-(int)isWinningAchievement { 
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MedalList" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    
    NSArray * arr = [dictionary objectForKey:@"Medal"];

    int trygetAc = -1;
    
    for (int i=0; i < [self.achievements count]; i++) {
        NSNumber * num = [self.achievements objectAtIndex:i];
        int n =[num intValue];
        NSLog(@"%d  value %d", i, n);
    }
    
    for (int i=0; i < [self.achievements count]; i++) {
        NSNumber * num = [self.achievements objectAtIndex:i];
        if ([num intValue] == 0)
        {
            trygetAc = i;  
        break;
        }
    }
    
    if (trygetAc != -1) {
         NSDictionary * dic = [arr objectAtIndex:trygetAc];
        int week = [[dic objectForKey:@"Week"] intValue];
        int day = [[dic objectForKey:@"Day"] intValue];
        
        NSLog(@"Medal Info: w1 d1 %d %d  ===  w2 d2 %d %d", week, day, insistWeeks, insistDays);
        
        if (week <= insistWeeks && day <= insistDays) {
            
            NSMutableArray * arr = [NSMutableArray arrayWithArray:self.achievements];
            [arr replaceObjectAtIndex:trygetAc withObject:[NSNumber numberWithInt:1]];
            self.achievements = arr;
            return trygetAc;
        }
    }
    
    return -1;  //-1 = nil else: got new one 
}

#pragma DateUtility
/**
 dayDifference: Get day difference 
 */
-(int)dayDifference:(NSDate *)fromDate to: (NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString * dateString1 =[formatter stringFromDate:fromDate];
    NSString * dateString2 =[formatter stringFromDate:date];
    
    NSDate * modi1 = [formatter dateFromString:dateString1];
    NSDate * modi2 = [formatter dateFromString:dateString2];
    
    [formatter release];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit;
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:modi1  toDate:modi2  options:0];
    int days = [comps day];
    
    [gregorian release];
    
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:modi1];
    int weekday1 = [componets weekday];
    
    NSDateComponents *componets2 = [[NSCalendar autoupdatingCurrentCalendar] components:NSWeekdayCalendarUnit fromDate:modi2];
    int weekday2 = [componets2 weekday];
    
    if (days > 1 && !(weekday2 == 2 && weekday1 >= 6) && !(weekday2 == 1 && weekday1 == 6)) {
        return 0;   
    }
    else {
        if (days == 1 || (weekday2 == 2 && weekday1 >= 6)) {
            return 2;
        }
        else if(days == 0){
            return 1;
        }
    }
    return YES;
}

@end
