//
//  ReadingFile.h
//  TestUI
//
//  Created by Ke Ye on 8/10/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadingFile : NSObject  {
    NSString * category;
    NSString * name;
    NSString * file;
    NSString * img;
    NSString * img2;
    NSString * content;
    int switchTime;
    int time;
    int imgNum;
    NSString * tips;
}
@property(nonatomic, retain) NSString * content;
@property(nonatomic, retain) NSString * category;
@property(nonatomic, retain) NSString * name;
@property(nonatomic, retain) NSString * file;
@property(nonatomic, retain) NSString * img;
@property(nonatomic, retain) NSString * img2;
@property(nonatomic, assign) int switchTime;
@property(nonatomic, assign) int time;
@property(nonatomic, assign) int imgNum;
@property(nonatomic, retain) NSString * tips;

-(id)initWith:(NSDictionary *)dict;

@end
