//
//  Sympthon.h
//  TestUI
//
//  Created by Ye Ke on 12/29/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Part.h"
#import "UserData.h"



@interface Sympthon : NSObject {
    int level;
    int answerindex;
}
@property(assign, nonatomic)int level;

+(void)setAllPartsandSympthons:(NSMutableArray *)answers;
+(double)calculateSymFac;

@end
