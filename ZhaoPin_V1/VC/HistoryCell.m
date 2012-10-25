//
//  HistoryCell.m
//  Zhaopin
//
//  Created by 马朋震 /Users/ibokan/Desktop/图片/523194.gif on 12-10-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell
@synthesize historySearch;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        historySearch = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 290, 30)];
        historySearch.backgroundColor = [UIColor clearColor];
        [historySearch setTextAlignment:UITextAlignmentLeft];
        [self.contentView addSubview:historySearch];
        [historySearch release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
