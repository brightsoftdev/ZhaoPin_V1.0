//
//  Job.h
//  DeV
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailJob : NSObject
@property (nonatomic,retain)NSString *jobName;
@property (nonatomic,retain)NSString *pay;
@property (nonatomic,retain)NSString *adress;
@property (nonatomic,retain)NSString *experience;
@property (nonatomic,retain)NSString *number;
@property (nonatomic,retain)NSString *details;
+ (DetailJob *)jobWithName:(NSString *)jobName pay:(NSString *)pay adress:(NSString *)adress experience:(NSString *)experience number:(NSString *)number details:(NSString *)details;
@end
