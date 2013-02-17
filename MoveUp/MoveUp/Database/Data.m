//
//  Data.m
//  TestUI
//
//  Created by FreeXue on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Data.h"
#import "DataBase.h"
#import "actionCount.h"
@implementation Data
@synthesize _id;
@synthesize date;
@synthesize head_1;   
@synthesize head_2; 
@synthesize head_3; 
@synthesize head_4; 
@synthesize wrist_1;
@synthesize finger_1;
@synthesize finger_2;
@synthesize elbow_1;
@synthesize elbow_2;
@synthesize neck_1;
@synthesize neck_2;
@synthesize neck_3;
@synthesize shoulder_1;
@synthesize shoulder_2;
@synthesize back_1;
@synthesize back_2;
@synthesize waist_1;
@synthesize waist_2;
@synthesize waist_3;
@synthesize leg_1;
@synthesize leg_2;
@synthesize leg_3;
@synthesize butt_1;



- (id)init
{
    self = [super init];
    if (self) {/*
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式 
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];//取当前时间值
        long long int date1 = (long long int)time;//转成long long
        NSLog(@"current number of sec: %lld", date1);//输出当前时间值
        //-----------------------------------------------------------------------------------------------------
        NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:date1];//将当前时间值转成日期类型
        NSLog(@"current date by sec: %@",currentDate); //输出当前日期
        
        */
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式 
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        

        self.date = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter release];
        _id=0;

        [date retain];
   
        head_1=NO;   
        head_2=NO;
        head_3=NO; 
        head_4=NO;
        wrist_1=NO;
        finger_1=NO;
        finger_2=NO;
        elbow_1=NO;
        elbow_2=NO;
        neck_1=NO;
        neck_2=NO;
        neck_3=NO;
        shoulder_1=NO;
        shoulder_2=NO;
        back_1=NO;
        back_2=NO;
        waist_1=NO;
        waist_2=NO;
        waist_3=NO;
        leg_1=NO;
        leg_2=NO;
        leg_3=NO;
        butt_1=NO;
     
    }
    return self;
}
////Data这个类的初始化方法
//- (id) initWithID:(NSString *) ID date:(NSString *) date head1:(NSString *) head1 head2:(NSString *) head2 head3:(NSString *) head3 head4:(NSString *) head4 wrise1:(NSString *)wrise1  finger1:(NSString *) finger1 finger2:(NSString *) finger2 elbow1:(NSString *) elbow1 elbow2:(NSString *) elbow2 neck1:(NSString *) neck1 neck2:(NSString *) neck2 shoulder1:(NSString *)shoulder1 back1 :(NSString *) back1 back2 :(NSString *) back2 waist1 :(NSString *) waist1 waist2:(NSString *) waist2 waist3:(NSString *) waist3 leg1 :(NSString *) leg1 leg2 :(NSString *) leg2 leg3 :(NSString *) leg3 ass1:(NSString *) ass1 {
//	if (self = [super init]) {
//		  _id = [ID retain];
//         _date=[date retain];
//         _head1=[head1 retain];   
//         _head2=[head2 retain];  
//         _head3=[head3 retain];   
//         _head4=[head4 retain];   
//         _wrise1=[wrise1 retain];
//         _finger1=[finger1 retain];
//         _finger2=[finger2 retain];
//         _elbow1=[elbow1 retain];
//         _elbow2=[elbow2 retain];
//         _neck1=[neck1 retain];
//         _neck2=[neck2 retain];
//         _shoulder1=[shoulder1 retain];
//         _back1=[back1 retain];
//         _back2=[back2 retain];
//         _waist1=[waist1 retain];
//         _waist2=[waist2 retain];
//         _waist3=[waist3 retain];
//         _leg1=[leg1 retain];
//         _leg2=[leg2 retain];
//         _leg3=[leg3 retain];
//         _ass1=[ass1 retain];
//	}
//	return self;
//}

-(NSMutableArray *) leastdo:(NSArray *)condition num:(int)num{
    NSMutableArray *result=[[NSMutableArray alloc] init];
    NSString *subsql = [NSString string];
    
    
    for (int i=0; i<condition.count; i++) {
        NSDictionary *dic=[condition objectAtIndex:i];
        
        NSLog(@"dic pART %@", [dic objectForKey:@"Category"]);
        if (i==0) {
            subsql=[NSString stringWithFormat:@"SELECT * FROM CHECKPOINT WHERE POSITION='%@' ",[[dic objectForKey:@"Name"] uppercaseString]];
        }
        else {
            subsql = [subsql stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"UNION SELECT * FROM CHECKPOINT WHERE POSITION='%@' ",[[dic objectForKey:@"Name"] uppercaseString]]];
        }
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM(%@) ORDER BY DATE ASC LIMIT 0,%d",subsql,num];
   // NSLog(@"%@",sql);
    //NSLog(@"%@",subsql);
    
    PLSqliteDatabase *dataBase = [DataBase setup];
    id<PLResultSet> rs;
    rs =[dataBase executeQuery:sql];
    while([rs next]) {
        [result addObject:[rs objectForColumn:@"POSITION"]];
        NSLog(@"result position : %@", [rs objectForColumn:@"POSITION"]);
           }
    return [result autorelease];
}


+(NSMutableArray *)initDic {
    NSMutableArray * parts = [[NSMutableArray alloc]init];
    
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"HEAD_1",@"Name", @"head",@"Category",nil];
    [parts addObject:dic];
    NSDictionary * dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"HEAD_2",@"Name", @"head",@"Category",nil];
    [parts addObject:dic2];
    NSDictionary * dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"SHOULDER_1",@"Name", @"shoulder",@"Category",nil];
    [parts addObject:dic3];
    NSDictionary * dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"LEG_1",@"Name", @"leg",@"Category",nil];
    [parts addObject:dic4];
    
    if (dic) {
        [dic release];
    }
    if (dic2) {
        [dic2 release];
    }
    if (dic3) {
        [dic3 release];
    }
    if (dic4) {
        [dic4 release];
    }
    return [parts autorelease];
}

-(void)setstatus:(NSString *)position{
    NSLog(@"%@",position);
    NSLog(@"neck before %d %d",self.neck_1,self.neck_2);
    if ([position isEqualToString: @"head_1"]) {
       self.head_1=YES;
    }

    if ([position isEqualToString: @"head_2"]) {
        self.head_2=YES;
    }  
 
    if ([position isEqualToString: @"head_3"]) {
        self.head_3=YES;
    }

    if ([position isEqualToString: @"head_4"]) {
        self.head_4=YES;
    } 

    if ([position isEqualToString: @"wrist_1"]) {
        self.wrist_1=YES;
    }

    if ([position isEqualToString: @"finger_1"]) {
        self.finger_1=YES;
    }  
 
    if ([position isEqualToString: @"finger_2"]) {
        self.finger_2=YES;
    }

    if ([position isEqualToString: @"elbow_1"]) {
        self.elbow_1=YES;
    }   

    if ([position isEqualToString: @"elbow_2"]) {
        self.elbow_2=YES;
    }

    if ([position isEqualToString: @"neck_1"]) {
        self.neck_1=YES;
    }  
    else {
        NSLog(@"it is not");
    }
    if ([position isEqualToString: @"neck_2"]) {
        self.neck_2=YES;
    }
    else {
        NSLog(@"it is not");
    }
    if ([position isEqualToString: @"neck_3"]) {
        self.neck_3=YES;
    }
    if ([position isEqualToString: @"shoulder_1"]) {
        self.shoulder_1=YES;
    } 
    if ([position isEqualToString: @"shoulder_2"]) {
        self.shoulder_2=YES;
    } 
    if ([position isEqualToString: @"back_1"]) {
        self.back_1=YES;
 
    }

    if ([position isEqualToString: @"back_2"]) {
        self.back_2=YES;
    }

    if ([position isEqualToString: @"waist_1"]) {
        self.waist_1=YES;
    }

    if ([position isEqualToString: @"waist_2"]) {
        self.waist_2=YES;
    }

    if ([position isEqualToString: @"waist_3"]) {
        self.waist_3=YES;
    }

    if ([position isEqualToString: @"butt_1"]) {
        self.butt_1=YES;
    }

    if ([position isEqualToString: @"leg_1"]) {
        self.leg_1=YES;
    }

    if ([position isEqualToString: @"leg_2"]) {
        self.leg_2=YES;
    }

    if ([position isEqualToString: @"leg_3"]) {
        self.leg_3=YES;
    }
    
    NSLog(@"neck after %d %d",self.neck_1,self.neck_2);

}


-(void) insertRecord{
    
    PLSqliteDatabase *dataBase = [DataBase setup];
    NSLog(@"the date is %@",self.date);
    NSString * str1 =  [NSString stringWithFormat:@"INSERT INTO HISTORY VALUES (null,'%@','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d')",self.date,self.head_1,self.head_2,self.head_3,self.head_4,self.wrist_1,self.finger_1,self.finger_2,self.elbow_1,self.elbow_2,self.neck_1,self.neck_2,self.neck_3,self.shoulder_1,self.shoulder_2,self.back_1,self.back_2,self.waist_1,self.waist_2,self.waist_3,self.leg_1,self.leg_2,self.leg_3,self.butt_1];
  
    
   [dataBase executeUpdate:str1];
    
    if (self.head_1) {//23
      NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='HEAD_1'",self.date];
     [dataBase executeUpdate:str];
    }
    if (self.head_2) {//22
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='HEAD_2'",self.date];
        [dataBase executeUpdate:str];
    }   
    if (self.head_3) {//21
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='HEAD_3'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.head_4) {//20
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='HEAD_4'",self.date];
        [dataBase executeUpdate:str];
    }   
    if (self.wrist_1) {//19
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='WRIST_1'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.finger_1) {//18
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='FINGER_1'",self.date];
        [dataBase executeUpdate:str];
    }    
    if (self.finger_2) {//17
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='FINGER_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.elbow_1) {//16
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='ELBOW_1'",self.date];
        [dataBase executeUpdate:str];
    }   
    if (self.elbow_2) {//15
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='ELBOW_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.neck_1) {//14
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='NECK_1'",self.date];
        [dataBase executeUpdate:str];
    }   
    if (self.neck_2) {//13
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='NECK_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.neck_3) {//12
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='NECK_3'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.shoulder_1) {//11
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='SHOULDER_1'",self.date];
        [dataBase executeUpdate:str];
    }   
    if (self.shoulder_2) {//10
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='SHOULDER_2'",self.date];
        [dataBase executeUpdate:str];
    } 
    if (self.back_1) {//9
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='BACK_1'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.back_2) {//8
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='BACK_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.waist_1) {//7
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='WAIST_1'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.waist_2) {//6
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='WAIST_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.waist_3) {//5
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='WAIST_3'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.butt_1) {//4
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='BUTT_1'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.leg_1) {//3
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='LEG_1'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.leg_2) {//2
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='LEG_2'",self.date];
        [dataBase executeUpdate:str];
    }
    if (self.leg_3) {//1
        NSString * str =  [NSString stringWithFormat:@"UPDATE CHECKPOINT SET DATE='%@' WHERE POSITION='LEG_3'",self.date];
        [dataBase executeUpdate:str];
    }




}


+(NSDictionary *)showCheckpoint{
    NSDictionary *dic=[[[NSDictionary alloc] init] autorelease];
    PLSqliteDatabase *dataBase = [DataBase setup];
    id<PLResultSet> rs;
    NSString * str =  [NSString stringWithFormat:@"SELECT * FROM CHECKPOINT"];
    rs =[dataBase executeQuery:str];
    while([rs next]) {
        [dic setValue:[rs stringForColumn:@"DATE"] forKey:[rs stringForColumn:@"POSITION"]];
      
    }
    return dic;
}

+(NSString *) recentfinish{
    PLSqliteDatabase *dataBase = [DataBase setup];
    id<PLResultSet> rs;
    NSString * str =  [NSString stringWithFormat:@"SELECT * FROM HISTORY ORDER BY ID DESC LIMIT 0,1 "];
    rs =[dataBase executeQuery:str];
    if([rs next]) {
      return [rs stringForColumn:@"DATE"];
    }
    else {
        return @"未完成";
    }

}

+(void) emptytable{
    PLSqliteDatabase *dataBase = [DataBase setup];
    NSString * str =  [NSString stringWithFormat:@"DELETE FROM HISTORY"];
    [dataBase executeUpdate:str];
}


+ (actionCount *) countEachAction{
    actionCount * actioncount;
    actioncount=[[[actionCount alloc]init] autorelease];
    PLSqliteDatabase *dataBase = [DataBase setup];
    id<PLResultSet> rs;
    NSString * str =  [NSString stringWithFormat:@"SELECT * FROM HISTORY"];
    rs =[dataBase executeQuery:str];
    while([rs next]) {
        NSLog(@"the date is %@",[rs stringForColumn:@"DATE"]);
        if ([rs boolForColumn:@"HEAD_1"]) {
            actioncount.head_1++;
            actioncount.head++;
        }
        if ([rs boolForColumn:@"HEAD_2"]) {
            actioncount.head_2++;
            actioncount.head++;
        }
        if ([rs boolForColumn:@"HEAD_3"]) {
            actioncount.head_3++;
            actioncount.head++;
        }
        if ([rs boolForColumn:@"HEAD_4"]) {
            actioncount.head_4++;
            actioncount.head++;
        }
        if ([rs boolForColumn:@"WRIST_1"]) {
            actioncount.wrise_1++;
            actioncount.wrise++;
        }
        if ([rs boolForColumn:@"FINGER_1"]) {
            actioncount.finger_1++;
            actioncount.finger++;
        }
        if ([rs boolForColumn:@"FINGER_2"]) {
            actioncount.finger_2++;
            actioncount.finger++;
        }
        if ([rs boolForColumn:@"ELBOW_1"]) {
            actioncount.elbow_1++;
            actioncount.elbow++;
        }
        if ([rs boolForColumn:@"ELBOW_2"]) {
            actioncount.elbow_2++;
            actioncount.elbow++;
        }
        if ([rs boolForColumn:@"NECK_1"]) {
            actioncount.neck_1++;
            actioncount.neck++;
        }
        if ([rs boolForColumn:@"NECK_2"]) {
            actioncount.neck_2++;
            actioncount.neck++;
        }
        if ([rs boolForColumn:@"NECK_3"]) {
            actioncount.neck_3++;
            actioncount.neck++;
        }
        if ([rs boolForColumn:@"SHOULDER_1"]) {
            actioncount.shoulder_1++;
            actioncount.shoulder++;
        }
        if ([rs boolForColumn:@"SHOULDER_2"]) {
            actioncount.shoulder_2++;
            actioncount.shoulder++;
        }
        if ([rs boolForColumn:@"BACK_1"]) {
            actioncount.back_1++;
            actioncount.back++;
        }
        if ([rs boolForColumn:@"BACK_2"]) {
            actioncount.back_2++;
            actioncount.back++;
        }
        if ([rs boolForColumn:@"WAIST_1"]) {
            actioncount.waist_1++;
            actioncount.waist++;
        }
        if ([rs boolForColumn:@"WAIST_2"]) {
            actioncount.waist_2++;
            actioncount.waist++;
        }
        if ([rs boolForColumn:@"WAIST_3"]) {
            actioncount.waist_3++;
            actioncount.waist++;
        }
        if ([rs boolForColumn:@"LEG_1"]) {
            actioncount.leg_1++;
            actioncount.leg++;
        }
        if ([rs boolForColumn:@"LEG_2"]) {
            actioncount.leg_2++;
            actioncount.leg++;
        }
        if ([rs boolForColumn:@"LEG_3"]) {
            actioncount.leg_3++;
            actioncount.leg++;
        }
        if ([rs boolForColumn:@"BUTT_1"]) {
            actioncount.butt_1++;
            actioncount.ass++;
        }
    }
    return actioncount;
}

@end
