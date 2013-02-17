//
//  Sympthon.m
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "Sympthon.h"

static float scores[4] = {4,3.2,1.3,1};
static int partscore[4] = {8,5,3,0};
@implementation Sympthon
@synthesize level;

-(id)init {
    
    if(self = [super init]) {
    }
    return self;
}

+(int)getAnswerScore:(int)index {
    return scores[index];
}

+(void)setAllPartsandSympthons:(NSMutableArray *)answers {
    
    ////////Pesuo Configs/////
    /*answers = [[NSMutableArray alloc]init];
    for (int k =0 ; k < 10; k ++) {
        [answers addObject:[NSNumber numberWithInt: arc4random()%9 ]];
    }*/
    
    ////////Real Code/////////
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Questions" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray * questions = [dictionary objectForKey:@"Questions"];

    NSMutableArray * parts = [[NSMutableArray alloc]init];
    NSMutableArray * sympthons = [[NSMutableArray alloc]init];
    
    NSArray * partNames = @[@"head",@"neck",@"shoulder",@"wrist",@"back",@"waist",@"butt",@"leg"];
    
    for (int i = 0; i < 8; i++) {
        Part * part = [[Part alloc]init];
        part.name = partNames[i];
        part.conditiontype = 0;
        part.status = 0;
        part.rawData = 0;
        part.lastExtime = [NSDate distantPast];
        [parts addObject:part];
    }
    
    int i =0;
    float progress;
    
    for(NSNumber * answer in answers)//All answers
    {
        
        float answerScore = scores[[answer intValue] - 1]; // 0 1 2 3
        
        NSLog(@"i = %d answer %f", i, answerScore);
        
        if (i == 2) {
            answerScore = scores[4 - [answer intValue]];
            answer = [NSNumber numberWithInt:5 - [answer intValue]];
        }
        
        NSDictionary * question = [questions objectAtIndex:i];
        NSArray * influ_parts = [question objectForKey:@"Influence"];
        for (NSDictionary * influ_part in influ_parts) { //All influenced parts, add influence to each part
            NSString * influ_name = [influ_part objectForKey:@"Part"];
            float influ_fac = [[influ_part objectForKey:@"Weight"] floatValue];
            
            if ([influ_name isEqualToString:@"overall"]) {
                for (Part *pt in parts) {
                    pt.rawData += influ_fac * partscore[[answer intValue] -1];
                }
            }
            else {
                for (Part *pt in parts) {
                    if ([pt.name isEqualToString:influ_name]) {
                        pt.rawData += influ_fac * partscore[[answer intValue] -1] ;
                    }
                }
            }
        }
        
        Sympthon * sympthon = [[Sympthon alloc]init];
        sympthon.level = [answer intValue];
        progress += answerScore;
        NSLog(@"progress %f", progress);
        [sympthons addObject:sympthon];
        i++;
    }
    
    /**
     Scaling progress
     **/
    
    if (progress >= 40) {
        progress = 40.0;
    }
    else {
        progress =  20.0 + (progress - 40) / 30 * 15;
    }
       
    [UserData sharedUser].progress = progress;
    [[UserData sharedUser] updateFitRate];
    //After the former For loop, parts and sympthons are generally set.
    //However, nned to correct parts.conditionType and allocate status.
    
    for (Part * pt in parts) {
        if (pt.rawData >= TYPEVALUE[ORDINARY]) { //8
            pt.conditiontype = ORDINARY;
            pt.status = COMMON;
        }
        else if(pt.rawData >= TYPEVALUE[POTENTIAL]) { //5
            pt.conditiontype = POTENTIAL;
            pt.status = MEDIUM;
        }
        else if(pt.rawData >= TYPEVALUE[HURT]) { //0
            pt.conditiontype = HURT;
            pt.status = BAD;
        }
        [pt printInfo];
    }

    [UserData sharedUser].parts = parts;
    [UserData sharedUser].sympthons = sympthons;
    [UserData sharedUser].sympthonFactor = [Sympthon calculateSymFac];
    [[UserData sharedUser] importUser];
}

+(double)calculateSymFac {
    
    double SymFac = 0;
    for (Sympthon *sym in [UserData sharedUser].sympthons) {
        SymFac += sym.level;
        SymFac *= 10;
        NSLog(@"Print %d ", sym.level);
    }
    SymFac /= 10;
    NSLog(@"SymFac %lf", SymFac);
    return SymFac;
}

@end
