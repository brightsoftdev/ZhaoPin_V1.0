//
//  SelectionPickerView.m
//  ZhilianCCCCoo
//
//  Created by 马朋震 /Users/ibokan/Desktop/图片/523194.gif on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectionPickerView.h"

@implementation SelectionPickerView
@synthesize contents;

+(SelectionPickerView *)pickerViewWithContents:(NSMutableArray *)contents withDelegate:(id)delegate1 withDataSource:(id)datasource1
{
    SelectionPickerView *s = [[SelectionPickerView alloc] init];
    if (s) 
    {
        s.contents = contents;
        s.delegate = delegate1;
        s.dataSource = datasource1;
    }
    return [s autorelease];
}
@end
