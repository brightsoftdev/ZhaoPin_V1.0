//
//  Company.m
//  DeV
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Company.h"

@implementation Company
@synthesize comName,classL,scale,industry,adress,details;
+ (Company *)comWithName:(NSString *)comName classL:(NSString *)classL scale:(NSString *)scale industry:(NSString*)industry adress:(NSString *)adress details:(NSString *)details
{
    Company *com = [[Company alloc]init];
    com.comName = comName;
    com.classL = classL;
    com.scale = scale;
    com.industry = industry;
    com.adress = adress;
    com.details = details;
    return [com autorelease];
}
@end
