//
//  DetailView.h
//  DeV
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DetailJob.h"
#import "Company.h"
#import "MapViewController.h"

@interface DetailView : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
    UIButton *jobBut;
    UIButton *comBut;
    BOOL istouchButton;
    
    NSString *number;
    
    UIAlertView *aalert;
    
    CLLocationCoordinate2D coordinate1;
    MapViewController *mapViewC;
    NSURLConnection *apply;
    NSMutableData *applyData;
    NSURLConnection *collection;
    NSMutableData *collectionData;

}
@property (nonatomic,retain)NSString *jobUrlStr;
@property (nonatomic,retain)NSString *comUrlStr;
@property (nonatomic,retain)Company *com;
@property (nonatomic,retain)DetailJob *jo;
@property (nonatomic,retain)NSMutableArray *jobNumber,*jobTitle;
@property(nonatomic,retain)NSString *comNumber;
@property(nonatomic,retain)UIButton *appBtn,*collectBtn,*similarBtn,*checkBtn;
@property (nonatomic,retain)UITabBar *tab;
@property(nonatomic,retain)NSString *uticket;

- (void)apply;

@end
