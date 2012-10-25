//
//  Company.h
//  DeV
//
//  Created by Ibokan on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject
@property (nonatomic,retain) NSString *comName,*classL,*scale,*industry,*adress,*details;
+ (Company *)comWithName:(NSString *)comName classL:(NSString *)classL scale:(NSString *)scale industry:(NSString*)industry adress:(NSString *)adress details:(NSString *)details;
@end
