//
//  Indicator.m
//  app
//
//  Created by Ibokan on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Indicator.h"
#import <QuartzCore/QuartzCore.h>

@implementation Indicator

+ (void)addIndicator:(UIView *)view
{
    UIImageView *indicatorImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"toast.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    indicatorImage.userInteractionEnabled = NO;
    indicatorImage.frame = CGRectMake(0, 0, view.frame.size.width,view.frame.size.height);
    indicatorImage.tag = 100;
    indicatorImage.layer.opacity = 0.9;
    
    UILabel *indicatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    indicatorLabel.center = CGPointMake(indicatorImage.center.x, indicatorImage.center.y-40);
    indicatorLabel.tag = 101;
    indicatorLabel.backgroundColor = [UIColor clearColor];
    indicatorLabel.textColor = [UIColor grayColor];
    indicatorLabel.text = @"载入中...";
    [indicatorLabel setTextAlignment:UITextAlignmentCenter];
    [indicatorImage addSubview:indicatorLabel];
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    indicator.tag = 102;
    indicator.center = indicatorImage.center;
    [indicator startAnimating];
    [indicatorImage addSubview:indicator];
    
    
    
    [view addSubview:indicatorImage];
    [indicatorLabel release];
    [indicator release];
    [indicatorImage release];
}

+ (void)removeIndicator:(UIView *)view
{
    if ([[view viewWithTag:100] isKindOfClass:[UIImageView class]]) {
        
        UIImageView *indicatorImage = (UIImageView *)[view viewWithTag:100];
        
        if ([[indicatorImage viewWithTag:101] isKindOfClass:[UILabel class]]) {
            
            UILabel *indicatorLabel = (UILabel *)[indicatorImage viewWithTag:101];
            [indicatorLabel removeFromSuperview];
        } 
        
        if ([[indicatorImage viewWithTag:102] isKindOfClass:[UIActivityIndicatorView class]]) {
            
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[indicatorImage viewWithTag:102];
            [indicator stopAnimating];
            [indicator removeFromSuperview];
        }
        
        [indicatorImage removeFromSuperview];
    }

}
@end
