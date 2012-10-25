//
//  Prompt.m
//  app
//
//  Created by Ibokan on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Prompt.h"
#import <QuartzCore/QuartzCore.h>

@implementation Prompt

+ (void)addPrompt:(UIView *)view text:(NSString *)text  //添加   text为要显示的字符串
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 40)];  
    label.tag = 100;
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial" size:15];
    label.center = CGPointMake(view.center.x,view.center.y-80);
    [label setTextAlignment:UITextAlignmentCenter];
    label.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.7];  //背景颜色和透明度
    [view addSubview:label];
    [label release];
}



+ (void)removePrompt:(UIView *)view   //移出
{
    if ([[view viewWithTag:100] isKindOfClass:[UILabel class]]) {
        
        UILabel *label = (UILabel *)[view viewWithTag:100];
        [UIView beginAnimations:@"fadeout" context:[[NSNumber numberWithFloat:label.layer.opacity] retain]];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:label:)];  //动画结束后运行的方法
        [UIView setAnimationDelegate:self];
        label.layer.opacity = 0;  //让透明度为0  动画中慢慢变为0
        [UIView commitAnimations];
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context label:(UILabel *)label
{
    if ([animationID isEqualToString:@"fadeout"]) {
        // Restore the opacity
        CGFloat originalOpacity = [(NSNumber *)context floatValue];  //得到原本的透明度 可以不要
        label.layer.opacity = originalOpacity;   
        [label removeFromSuperview];  //移出试图
        [(NSNumber *)context release];
    }
}

@end
