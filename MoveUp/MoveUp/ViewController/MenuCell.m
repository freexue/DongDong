//
//  MenuCellCell.m
//  TestUI
//
//  Created by Ke Ye on 8/3/12.
//  Copyright (c) 2012 New Success. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
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
