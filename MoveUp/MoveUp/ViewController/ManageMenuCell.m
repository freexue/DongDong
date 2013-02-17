//
//  ManageMenuCell.m
//  TestUI
//
//  Created by FreeXue on 12-8-13.
//  Copyright (c) 2012年 New Success. All rights reserved.
//

#import "ManageMenuCell.h"

@implementation ManageMenuCell

@synthesize titleLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
