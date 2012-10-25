//
//  JobDetailVC.m
//  Zhaopin
//
//  Created by Ibokan on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define PRIVATEMETHEODS - (void)sendRequest;- (void)setViewContent;- (NSString *) getMD5String:(NSString *)url;- (NSString *)md5:(NSString *)str;

#define NOMAL - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];if (self) {}return self;}- (void)didReceiveMemoryWarning{[super didReceiveMemoryWarning];}

#define MD5 - (NSString *) getMD5String:(NSString *)url{	NSDate *date = [NSDate date];NSTimeInterval timeInterval = [date timeIntervalSince1970];NSString *paramT = [NSString stringWithFormat:@"%f", timeInterval];NSString *md5src = [NSString stringWithFormat:@"%fA42F7167-6DB0-4A54-84D4-789E591C31DA", timeInterval];NSString *md5Result = [self md5:md5src];NSLog(@"md5:%@", md5Result);NSString *result = nil;if (NSNotFound == [url rangeOfString:@"?"].location) {result = [NSString stringWithFormat:@"%@?t=%@&e=%@&f=p&d=%@",url, paramT, md5Result,md5src];}else {result = [NSString stringWithFormat:@"%@&t=%@&e=%@&f=p&d=%@",url, paramT, md5Result,md5src];}	return result;	}-(NSString *)md5:(NSString *)str { const char *cStr = [str UTF8String]; unsigned char result[32]; CC_MD5( cStr, strlen(cStr), result ); return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15] ]; }

#define CONNECTIONDELEGATE - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{ }- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)reponse{_data = [[NSMutableData alloc]init];}- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{[_data appendData:data];}- (void)connectionDidFinishLoading:(NSURLConnection *)connection{[Indicator removeIndicator:self.view];[self setViewContent];}

#define SENDERREQUEST NSURL *url = [[NSURL alloc]initWithString:[self getMD5String:string]]; NSLog(@"%@",url);NSURLRequest *request =[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];[url release];NSURLConnection  *_connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];[request release];[_connection release];
#define NSLOGXML NSString *str = [[NSString alloc]initWithData:_data encoding:NSUTF8StringEncoding];NSLog(@"%@",str);



#import "JobDetailVC.h"
#import "Indicator.h"
#import <CommonCrypto/CommonDigest.h>
#import "MarkedJob.h"
#import "GDataXMLNode.h"
#import "RecordCell.h"
#import "PrettyKit.h"
#import "LeveyHUD.h"
#import "JobDetailVC.h"
#import "MapViewController.h"


@implementation JobDetailVC
@synthesize jobNumber;
@synthesize jobTitle;
@synthesize jobCity;
@synthesize work;
@synthesize salary;
@synthesize number;
@synthesize detail;
@synthesize jobView;
@synthesize companyView;
@synthesize companyTitle;
@synthesize companyType;
@synthesize companySize;
@synthesize companyKind;
@synthesize companyAddress;
@synthesize companyDetail;
@synthesize companyButton;
@synthesize jobButton;
@synthesize applyBtn;
@synthesize favoriteBtn;
@synthesize sameBtn;
@synthesize positionBtn;


@interface JobDetailVC(private)
PRIVATEMETHEODS 
- (void)getUticket ;

@end

- (void)getUticket  //获取身份标识
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"user.txt"];   
    NSDictionary *userDic = [NSDictionary dictionaryWithContentsOfFile:filePath];  
    uticket = [userDic objectForKey:@"uticket"];
    [uticket retain];
}

//实现发送网络请求的方法
- (void)sendRequest
{
    [self getUticket];
    NSString *string = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/showjobdetail.aspx?job_number=%@&uticket=%@",self.jobNumber,uticket];
    SENDERREQUEST
}
//实现设置view的内容的方法
- (void)setViewContent
{
    _List = [[NSMutableArray alloc]init];
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:_data options:0 error:nil];
    GDataXMLElement *root = [document rootElement];
    
    jobTitle.text = [[[root nodesForXPath:@"currentjob/job_title" error:nil]objectAtIndex:0]stringValue];
    salary.text = [[[root nodesForXPath:@"currentjob/salary_range" error:nil]objectAtIndex:0]stringValue];
    jobCity.text = [[[root nodesForXPath:@"currentjob/job_city" error:nil]objectAtIndex:0]stringValue];
    work.text = [[[root nodesForXPath:@"currentjob/working_exp" error:nil]objectAtIndex:0]stringValue];
     number.text = [[[root nodesForXPath:@"currentjob/number" error:nil]objectAtIndex:0]stringValue];
    detail.text = [[[root nodesForXPath:@"currentjob/responsibilty" error:nil]objectAtIndex:0]stringValue];
    
    

    companyTitle.text = [[[root nodesForXPath:@"//company_name" error:nil]objectAtIndex:0]stringValue];
    companyType.text = [[[root nodesForXPath:@"//company_property" error:nil]objectAtIndex:0]stringValue];
    companySize.text = [[[root nodesForXPath:@"//company_size" error:nil]objectAtIndex:0]stringValue];
    companyKind.text = [[[root nodesForXPath:@"//industry" error:nil]objectAtIndex:0]stringValue];
    companyAddress.text = [[[root nodesForXPath:@"//address" error:nil]objectAtIndex:0]stringValue];
    companyDetail.text = [[[root nodesForXPath:@"//company_desc" error:nil]objectAtIndex:0]stringValue];
    
    [self passByValueAndInitGeocoder ];

    [document release ];
}


#pragma mark - 交互方法
- (IBAction)back:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showJob
{
    jobView.hidden = NO;
    companyView.hidden = YES;
}
- (void)showCompany
{
    jobView.hidden = YES;
    companyView.hidden = NO;
}

- (void)apply
{
    [[LeveyHUD sharedHUD] appearWithText:@"职位申请中..."];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(removeAlertView) userInfo:nil repeats:NO];
}

- (void)favorite
{
    [[LeveyHUD sharedHUD] appearWithText:@"职位收藏中..."];
    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(removeAlertView) userInfo:nil repeats:NO];
}

- (void)same
{
   
}

-(void)passByValueAndInitGeocoder//初始化Geocoder和属性传 “公司的名字和招聘的职位的名称”的值
{
    mapViewC = [[MapViewController alloc]init];
    
    CLGeocoder* geocoder1 = [[CLGeocoder alloc] init];
    // NSString *str=[NSString stringWithFormat:@"北京市石景山石景山路42号石景山区总工会"];
    NSString *str=companyAddress.text;
    mapViewC.endPoint=str;
    
    //将汉字地址转换成coordinate（经纬度）
    [geocoder1 geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        mapViewC.fromecorrdinate = placemark.location.coordinate;
//        mapViewC.fromecorrdinate = coordinate1;
//        .
  
    
    mapViewC.jobAddress = companyTitle.text;
    mapViewC.jobName = jobTitle.text;
    //NSLog(@"%@",mapViewC.jobAddress);
        NSLog(@"  %f, 11 %f",mapViewC.fromecorrdinate.latitude,mapViewC.fromecorrdinate.longitude);
        
    }];
}


- (void)position
{
   
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:@"cube"];//私有API 会被拒的
    //  [animation setSubtype:kCATransitionFromTop];
    [animation setSubtype:@"endProgress"];
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController pushViewController:mapViewC animated:NO];
    
}

#pragma mark - 移除警告提示视图

- (void)removeAlertView
{
    [[LeveyHUD sharedHUD] delayDisappear:1.0f withText:@"操作成功"]; 
}

#pragma mark - View lifecycle
//view刚要加载时发送网络请求
- (void)viewWillAppear:(BOOL)animated
{
     
    
    [jobButton addTarget:self action:@selector(showJob) forControlEvents:UIControlEventTouchUpInside ];
    [companyButton addTarget:self action:@selector(showCompany) forControlEvents:UIControlEventTouchUpInside ];
    companyView.hidden = YES;
    [applyBtn addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchUpInside ];
    [favoriteBtn addTarget:self action:@selector(favorite) forControlEvents:UIControlEventTouchUpInside ];
    [sameBtn addTarget:self action:@selector(same) forControlEvents:UIControlEventTouchUpInside ];
    [positionBtn addTarget:self action:@selector(position) forControlEvents:UIControlEventTouchUpInside ];

    mapViewC = [[MapViewController alloc]initWithNibName:@"MapViewController" bundle:nil];
    
    [[LeveyHUD sharedHUD] appearWithText:@"数据加载中..."];
    
    [self sendRequest];
    
}
- (void)viewDidUnload 
{
    [mapViewC release ];
    [_data release];
    [self setFavoriteBtn:nil];
    [self setSameBtn:nil];
    [self setPositionBtn:nil];
   [self setApplyBtn:nil];
    [self setJobButton:nil];
    [self setCompanyButton:nil ];
    [self setJobTitle:nil];
    [self setJobCity:nil];
    [self setWork:nil];
    [self setSalary:nil];
    [self setNumber:nil];
    [self setDetail:nil];
    [self setJobView:nil];
    [self setCompanyView:nil];
    [self setCompanyTitle:nil];
    [self setCompanyType:nil];
    [self setCompanySize:nil];
    [self setCompanyKind:nil];
    [self setCompanyAddress:nil];
    [self setCompanyDetail:nil];
    [super viewDidUnload];
}


#pragma mark -私有方法    
MD5
//发送网络请求失败时，执行的方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[LeveyHUD sharedHUD] disappear];
}
//服务器响应请求,初始化存放xml数据的_data
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)reponse
{
    _data = [[NSMutableData alloc]init];
}
//接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
//完成数据接收,设置文章视图显示的内容
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //移除网络状况提示视图
    [[LeveyHUD sharedHUD] disappear];
    [self setViewContent];
}

- (void)dealloc 
{
    [favoriteBtn release];
    [sameBtn release];
    [positionBtn release];
    [applyBtn release];
    [jobButton release ];
    [companyButton release ];
    [jobTitle release];
    [jobCity release];
    [work release];
    [salary release];
    [number release];
    [detail release];
    [jobView release];
    [companyView release];
    [companyTitle release];
    [companyType release];
    [companySize release];
    [companyKind release];
    [companyAddress release];
    [companyDetail release];
    [super dealloc];
}



@end
