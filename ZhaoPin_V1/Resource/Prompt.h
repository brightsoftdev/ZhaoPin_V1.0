//
//  Prompt.h
//  app
//
//  Created by Ibokan on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prompt : NSObject
+ (void)addPrompt:(UIView *)view text:(NSString *)text;
+ (void)removePrompt:(UIView *)view;

@end
