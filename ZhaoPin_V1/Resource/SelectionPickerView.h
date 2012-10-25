//
//  SelectionPickerView.h
//  ZhilianCCCCoo
//
//  Created by 马朋震 /Users/ibokan/Desktop/图片/523194.gif on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectionPickerView : UIPickerView

@property (nonatomic,retain) NSMutableArray *contents;//pickerView选项内容

+(SelectionPickerView *)pickerViewWithContents:(NSMutableArray *)contents withDelegate:(id)delegate1 withDataSource:(id)datasource1;
@end
