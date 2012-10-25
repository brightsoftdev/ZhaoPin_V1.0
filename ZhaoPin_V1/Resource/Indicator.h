//
//  Indicator.h
//  app
//
//  Created by Ibokan on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Indicator : NSObject

//添加网络指示器
+ (void)addIndicator:(UIView *)view;
//移除网络指示器
+ (void)removeIndicator:(UIView *)view;

@end
