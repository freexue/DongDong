//
//  ExercisePicker.h
//  TestUI
//
//  Created by Ye Ke on 12/27/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"
#import "UserData.h"

@interface ExercisePicker : NSObject {

}

+(NSArray *)extractFromActionPlist:(NSArray *)exerciseOrders;
+(NSArray *)loadInfo:(NSMutableArray *)pArr;
+(NSMutableArray *)changeOrder:(NSMutableArray* )orders with:(int)type;
+(NSMutableArray *)updateOrder:(NSMutableArray* )orders with: (NSMutableArray *)array;
+(void)searchForFiles:(NSArray *)orders;
+(void)PrintArr:(NSArray *)arr and:(NSString *)name;
+(NSMutableArray *)setParts;

//---------------------New Methods--------------------//
+(NSMutableArray *)choosePart:(int)num;
//+(NSMutableArray *)chooseEx:(int)num;
+(void)updateExandParts:(NSMutableArray *)exArr;
+(NSMutableArray *)getParts:(int)num ofLeastDoParts:(NSMutableArray *)parts;
+(NSMutableArray *)getnumbers:(int)num ofLeastDoExs:(NSMutableArray *)parts;
+(BOOL)is:(NSDate * )dt1 MoreRecnetThan:(NSDate *)dt2;
+(BOOL)moveDoc;
+(BOOL)updatePLIST;
@end
