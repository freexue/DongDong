//
//  SystemConfig.h
//  TestUI
//
//  Created by Ye Ke on 12/24/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>
#define XIBNameFor(str) [SystemConfig isIphone5]?([NSString stringWithFormat:@"%@-568h",str]):str
#define IP @"http://223.4.134.183"
#define Directory @"/app/index.php/" 

@interface SystemConfig : NSObject {
    //223.4.134.183"
}

+(Boolean)isIphone5;
+(float)getVersion;
+(Boolean)isJustUpdated;
+(void)setNeedUpdateStatus:(BOOL)status;
+(Boolean)needRemindUpdate;

@end
