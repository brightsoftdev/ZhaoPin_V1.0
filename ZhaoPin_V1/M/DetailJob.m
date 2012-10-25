//
//  Job.m
//  DeV
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailJob.h"

@implementation DetailJob

@synthesize jobName,pay,adress,experience,number,details;
+ (DetailJob *)jobWithName:(NSString *)jobName pay:(NSString *)pay adress:(NSString *)adress experience:(NSString *)experience number:(NSString *)number details:(NSString *)details
{
    DetailJob *jo = [[DetailJob alloc]init];
    jo.jobName = jobName;
    jo.adress = adress;
    jo.pay = pay;
    jo.experience = experience;
    jo.number = number;
    jo.details = details;
    return [jo autorelease];
}
@end