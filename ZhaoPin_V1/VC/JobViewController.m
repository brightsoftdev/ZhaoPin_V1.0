//
//  JobViewController.m
//  JobViewController
//
//  Created by 吴育星on 12-10-10.

#import "JobViewController.h"
#import "GDataXMLNode.h"
#import "Job.h"
#import "EncryptURL.h"
#import "Indicator.h"
#import "Prompt.h"
#import "JobCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailView.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImage+Scale.h"
#import "MapViewController.h"


@interface JobViewController()  //私有方法

- (void)customNavigationBar;  //自定义navigationbar;
- (void)initPickerView;  //初始化pickerview
- (void)getUticket;   //获取身份标识
- (void)sendSourceDataRequest:(NSString *)urlStr; //发送url请求取得XML数据
- (void)getSourceData;  //当接收完数据调用  解析XML数据 
- (void)sendApplyPositionRequest:(NSString *)urlStr; //申请职位
- (void)getApplyPositionData;   //解析申请职位返回的XML数据   
- (void)sendPositionSearch:(NSString *)urlStr;  //保存职位搜索器
- (void)getPositionSearchData; //解析保存职位搜索器返回的XML数据
- (void)initCellButtonIsSelectArr;  //初始化保存职位是否选中的数组
- (void)initSearchBar;  //加搜索器

@end

@implementation JobViewController
@synthesize changeRangeButton;
@synthesize changeRangeLabel;
@synthesize sourceDataTableView;
@synthesize sourceData,positionSearch,applyPosition;
@synthesize sourceConnection,positionConnection,applyConnection;
@synthesize urlString,positionSearchString;
@synthesize jobArr,pickerData;
@synthesize picker;
@synthesize toolBarAndPickerView;
@synthesize range,searchBar;
@synthesize cellButtonIsSelectArr;
@synthesize label,searchBarName;
@synthesize searchBarView;
@synthesize meLocation;
@synthesize searchBarTxt;
@synthesize signUpAlert;

- (void)dealloc 
{
    [jobbNumber release];
    jobbNumber = nil;
    self.searchBarTxt = nil;
    self.meLocation = nil;
    self.searchBarView = nil;
    self.searchBarName = nil;
    self.searchBar = nil;
    self.label = nil;
    self.cellButtonIsSelectArr = nil;
    self.toolBarAndPickerView = nil;
    self.picker = nil;
    self.pickerData = nil;
    uticket = nil;
    self.range = nil;
    self.sourceConnection = nil;
    self.positionConnection = nil;
    self.applyConnection = nil;
    self.positionSearch = nil;
    self.applyPosition = nil;
    self.sourceData = nil;
    self.urlString = nil;
    self.jobArr = nil;
    self.positionSearchString = nil;
    [changeRangeButton release];
    [sourceDataTableView release];
    [changeRangeLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    jobbNumber = [[NSString alloc]init];
    [self.changeRangeButton setTitle:self.range forState:UIControlStateNormal]; //调整当前位置的标题
    [self customNavigationBar]; //自定义navigationbar
    [self initPickerView];    //初始化pickerview
    [self initSearchBar];   //初始化搜索器
    [self sendSourceDataRequest:self.urlString]; //发送url请求取得XML数据
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUticket];  //获取身份标识

}

#pragma mark 按钮方法

- (void)applyPositionTo  //点击申请职位按钮
{
    //[Indicator removeIndicator:self.view];
    
    BOOL haveSelect = NO;  //是否有被选中的职位
    
    for(NSString *str in self.cellButtonIsSelectArr)
    {
        if (![str isEqualToString:@"-1"]) {
            
            haveSelect = YES;
        }
    }
    
    if (haveSelect == NO) 
    {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您还未选中任何职位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        
    } else {
    
        if (uticket == nil) {  //是否登陆
            
            self.signUpAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您还未登陆,无法提交简历" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"登陆", nil];
            [self.signUpAlert show];
            [signUpAlert release];
        
        } else {
            
            
            int selectNum = 1;

            for(int i = 0; i < [cellButtonIsSelectArr count] ; i++)
            {
                
                NSString *str = [cellButtonIsSelectArr objectAtIndex:i];
                
                
                if (![str isEqualToString:@"-1"]) {
                    
                    
                    if (selectNum > 1) {
                        
                        Job *job = [self.jobArr objectAtIndex:[str intValue]];
                        jobbNumber = [jobbNumber stringByAppendingFormat:@",%@",job.number];
                        
                    } else {
                        
                        Job *job = [self.jobArr objectAtIndex:[str intValue]];
                        NSLog(@"%@",job.number);
                        jobbNumber = [str stringByAppendingFormat:@"%@",job.number];
                        selectNum++;
                    }
                    
                }
                
            }
            
            jobbNumber = [jobbNumber substringFromIndex:1];
            
            EncryptURL *e = [[EncryptURL alloc]init];

            
            NSDictionary *dic  = [NSDictionary dictionaryWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"user.txt"]];
                        
            
            NSString *urlSt = [e getMD5String:[NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/myzhaopin/loginmgr/login.aspx?loginname=%@&password=%@",[dic objectForKey:@"username"],[dic objectForKey:@"password"]]];
            NSString *data = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlSt] encoding:NSUTF8StringEncoding error:nil];
            
          
            GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:data options:0 error:nil];
            
            GDataXMLElement *root = [document rootElement];
            NSString *resume_id = [[[root nodesForXPath:@"//resume_id" error:nil]objectAtIndex:0]stringValue];
            NSString *resume_number = [[[root nodesForXPath:@"//resume_number" error:nil]objectAtIndex:0]stringValue];
            NSString *version_number = [[[root nodesForXPath:@"//version_number" error:nil]objectAtIndex:0]stringValue];
            
            NSLog(@"%@ %@ %@",resume_id,resume_number,version_number);
            
            NSString *urlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/batchaddposition.aspx?uticket=%@&Resume_id=%@&Resume_number=%@&Version_number=%d&Job_number=%@&needSetDefResume=1",uticket,resume_id,resume_number,6,jobbNumber];
            NSLog(@"%@",urlStr);
            [self sendApplyPositionRequest:urlStr];
        }
    }     
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
}

- (IBAction)touchRangeButton:(id)sender  //点击出现pickerView选这范围
{
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
    [UIView animateWithDuration:0.5 animations:^{
        
        self.changeRangeButton.userInteractionEnabled = NO;
        self.toolBarAndPickerView.frame = CGRectMake(0,267, 320, 30);
        self.picker.frame = CGRectMake(0, 297, 320, 100);

    }];
}

- (void)downToolBarAndPickerView   //选定范围重新加载数据
{
    [UIView animateWithDuration:0.5 animations:^{
        
        [UIView setAnimationDidStopSelector:@selector(reloadDataSource)];
        [UIView setAnimationDelegate:self];
        self.changeRangeButton.userInteractionEnabled = YES;
        self.toolBarAndPickerView.frame = CGRectMake(0, 460, 320, 30);
        self.picker.frame = CGRectMake(0, 490, 320, 100);

    }];
}


- (void)addSearchBar:(UIButton *)btn   //点击navigationbar的中间搜索器
{
    if ([self.label.text isEqualToString:@"保存搜索器▼"])
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            self.changeRangeLabel.frame = CGRectMake(self.changeRangeLabel.frame.origin.x,self.changeRangeLabel.frame.origin.y+175, self.changeRangeLabel.frame.size.width, self.changeRangeLabel.frame.size.height);
            
            self.changeRangeButton.frame = CGRectMake(self.changeRangeButton.frame.origin.x, self.changeRangeButton.frame.origin.y + 175, self.changeRangeButton.frame.size.width, self.changeRangeButton.frame.size.height);
            
            self.sourceDataTableView.frame = CGRectMake(self.sourceDataTableView.frame.origin.x, self.sourceDataTableView.frame.origin.y +175, self.sourceDataTableView.frame.size.width, self.sourceDataTableView.frame.size.height);
            
            self.searchBarView.frame = CGRectMake(0, 0, 320, 175);
        }];
        
        if (searchBarName != nil) {
            
            [searchBarName becomeFirstResponder];
        }

        
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.changeRangeLabel.frame = CGRectMake(self.changeRangeLabel.frame.origin.x, self.changeRangeLabel.frame.origin.y - 175, self.changeRangeLabel.frame.size.width, self.changeRangeLabel.frame.size.height);
            
            self.changeRangeButton.frame = CGRectMake(self.changeRangeButton.frame.origin.x, self.changeRangeButton.frame.origin.y - 175, self.changeRangeButton.frame.size.width, self.changeRangeButton.frame.size.height);
            
            self.sourceDataTableView.frame = CGRectMake(self.sourceDataTableView.frame.origin.x, self.sourceDataTableView.frame.origin.y - 175, self.sourceDataTableView.frame.size.width, self.sourceDataTableView.frame.size.height);
            
            self.searchBarView.frame = CGRectMake(0, -175, 320, 175);
        }];
        
        
        [searchBarName resignFirstResponder];

    }

    self.label.text = [self.label.text isEqualToString:@"保存搜索器▼"] ? @"保存搜索器▲" : @"保存搜索器▼";

}

- (void)storageSearchBar:(UIButton *)btn  //点击保存搜索器
{
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
    
    UIView *view = [btn superview];
    [btn setHidden:YES];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 2, 250,30)];
    nameLabel.tag = 102;
    nameLabel.text = @"增加职位搜索器";
    nameLabel.font = [UIFont fontWithName:@"Arial" size:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    [view addSubview:nameLabel];
    [nameLabel release];
    
    self.searchBarName = [[[UITextField alloc]initWithFrame:CGRectMake(5, 35, 250, 30)]autorelease];
    [self.searchBarName setBorderStyle:UITextBorderStyleRoundedRect];
    [view addSubview:self.searchBarName];
    self.searchBarName.delegate = self;
    self.searchBarName.placeholder = @"请输入搜索器名称";
    [self.searchBarName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.searchBarName setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.searchBarName setReturnKeyType:UIReturnKeyDone];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.tag = 103;
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"columnNormalBg.png"] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"columnSelectedBg.png"] forState:UIControlStateHighlighted];
    sureButton.layer.cornerRadius = 3;
    sureButton.clipsToBounds = YES;
    sureButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
    sureButton.frame = CGRectMake(270, 35, 40, 28);
    [sureButton addTarget:self action:@selector(sureStorage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sureButton];
    
    [searchBarName becomeFirstResponder];
    
}

- (void)sureStorage  //点击确定
{
    
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
    if ([searchBarName.text isEqualToString:@""]) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入搜索器名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        
    } else {
        
        if (uticket == nil) {
            
            self.signUpAlert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您还未登陆,无法保存搜索器" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"登陆", nil];
            [self.signUpAlert show];
            [signUpAlert release];
            
        } else {

            NSString *searchUrlString = [[self.urlString stringByReplacingOccurrencesOfString:@"http://wapinterface.zhaopin.com/iphone/search/searchjob.aspx" withString:[NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/search/saveresult.aspx?uticket=%@&searcher_name=%@",uticket,searchBarName.text]]stringByReplacingOccurrencesOfString:@"&page=1&pagesize=30&sort=zf" withString:@""];
            //NSLog(@"%@",searchUrlString);
            
            [self sendPositionSearch:searchUrlString];
            
        }
    }
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
}

- (void)changeImage:(UIButton *)btn  //点击cell左边的按钮 改变保存哪个按钮被选中的按钮
{
    btn.selected = !btn.selected;
    //NSLog(@"%@",self.cellButtonIsSelectArr);
    
    if ([[self.cellButtonIsSelectArr objectAtIndex:btn.tag]intValue] == -1) {
        
        NSString *str = [NSString stringWithFormat:@"%d",btn.tag];
        [self.cellButtonIsSelectArr replaceObjectAtIndex:btn.tag withObject:str];
        
    } else {
        
        NSString *str = @"-1";
        [self.cellButtonIsSelectArr replaceObjectAtIndex:btn.tag withObject:str];
        
    }
    //NSLog(@"%@",self.cellButtonIsSelectArr);
    
}

#pragma mark 动画代理方法

- (void)reloadDataSource  //picker动画结束后执行
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    if (![range isEqualToString:@"不选择"]) {
        
        [self sendSourceDataRequest:self.urlString];
    }
}
 
- (void)resetSearchBar  //搜索器上升消失后
{
    UIView *view2 = [searchBarView viewWithTag:100];
    [[view2 viewWithTag:102]removeFromSuperview];
    [self.searchBarName removeFromSuperview];
    [[view2 viewWithTag:103]removeFromSuperview];
    [[view2 viewWithTag:101] setHidden:NO];
    //NSLog(@"%s %d",__FUNCTION__,__LINE__);
}

#pragma mark 私有方法


- (void)customNavigationBar  //自定义navigationbar
{
    //返回按钮
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"setting-form-back-button"]scaleToSize:CGSizeMake(30, 35)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"setting-form-back-button-click"]scaleToSize:CGSizeMake(30, 35)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    //申请职位按钮
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:@"Arial" size:13];
    [button setTitle:@"申请" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"setting-button.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"setting-button-click.png"] forState:UIControlStateHighlighted];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button addTarget:self action:@selector(applyPositionTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *applyPositonBar = [[[UIBarButtonItem alloc]initWithCustomView:button]autorelease];;
    self.navigationItem.rightBarButtonItem = applyPositonBar;
    
    
    //保存搜索器按钮
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 35)];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110, 35)];
    btn.tag = 100;
    [btn addTarget:self action:@selector(addSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 35)];
    self.label.tag = 101;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    [self.label setTextAlignment:UITextAlignmentCenter];
    self.label.text = @"保存搜索器▼";

    
    [view addSubview:self.label];
    [view addSubview:btn];
    [self.label release];
    
    [self.navigationItem setTitleView:view];
    [view release];
    
}

- (void)initPickerView  //初始化pickerview
{
    self.toolBarAndPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 460, 320, 30)];
    
    
    UITabBar *tabBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.showsTouchWhenHighlighted = YES;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.frame = CGRectMake(250, 0, 50, 30);
    [btn addTarget:self action:@selector(downToolBarAndPickerView) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pickerData = [[NSMutableArray alloc]initWithObjects:@"不选择",@"1公里",@"3公里",@"5公里", nil];
    self.picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,490, 320, 100)];
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self.picker setShowsSelectionIndicator:YES];
    
    [self.toolBarAndPickerView addSubview:tabBar];
    [self.toolBarAndPickerView addSubview:btn];
    
    [self.tabBarController.view.superview addSubview:toolBarAndPickerView];
    [self.tabBarController.view.superview addSubview:self.picker];
    
    
    [tabBar release];
    [self.pickerData release];
    [self.picker release];
    [self.toolBarAndPickerView release];

}

- (void)initSearchBar   //加搜索器
{
  
    self.searchBarView = [[[UIView alloc]initWithFrame:CGRectMake(0, -175, 320, 175)]autorelease];
    self.searchBarView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"centerBackground.png"]];
    
    UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, 30)];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.text = @"搜索条件";
    searchLabel.textColor = [UIColor whiteColor];
    [self.searchBarView addSubview:searchLabel];
    [searchLabel release];
    
    UILabel *searchLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, 310, 40)];
    searchLabel1.backgroundColor = [UIColor clearColor];
    searchLabel1.numberOfLines = 0;     
    searchLabel1.font = [UIFont fontWithName:@"Arial" size:12];
    
    if ([self.searchBarTxt count] > 0) {
        
        searchLabel1.text = [self.searchBarTxt objectAtIndex:0];
        
        for(int i = 1 ; i < [self.searchBarTxt count]; i++)//NSString *str in self.searchBarTxt)
        {
            
            searchLabel1.text = [searchLabel1.text stringByAppendingString:[[NSString alloc]initWithFormat:@"+%@",[self.searchBarTxt objectAtIndex:i]]];
        }
    }

    searchLabel1.textColor = [UIColor whiteColor];
    [self.searchBarView addSubview:searchLabel1];
    [searchLabel1 release];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 95, 320, 70)];
    view2.tag = 100;
    view2.backgroundColor = [UIColor clearColor];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.tag = 101;
    searchBtn.layer.cornerRadius = 5;
    searchBtn.clipsToBounds = YES;
    searchBtn.frame = CGRectMake(5, 20, 310, 30);
    [searchBtn setTitle:@"保存为职位搜索器" forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"columnNormalBg.png"] forState:UIControlStateNormal];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"columnSelectedBg.png"] forState:UIControlStateHighlighted];
    [searchBtn addTarget:self action:@selector(storageSearchBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [view2 addSubview:searchBtn];
    [self.searchBarView addSubview:view2];
    [view2 release];

                        
    [self.view addSubview:self.searchBarView];
}

- (void)initCellButtonIsSelectArr  //初始化哪个按钮被选中的数组
{
    self.cellButtonIsSelectArr = [[NSMutableArray alloc]init];
    
    for (int i = 0;i < [self.jobArr count]; i++) {  //未选中设置为-1,选中则为职位所在的row
        
        NSString *str = @"-1";
        [self.cellButtonIsSelectArr addObject:str];
    }
    
    [self.cellButtonIsSelectArr release];
}

- (void)getUticket  //获取身份标识
{
    NSString *uticketPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"uticket.txt"];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:uticketPath]) {
        
        uticket = [NSString stringWithContentsOfFile:uticketPath encoding:NSUTF8StringEncoding error:nil];
        [uticket retain];
    }
}

- (void)sendSourceDataRequest:(NSString *)urlStr  //发送数据源的url请求取得XML数据
{

    NSRange rangee = [urlStr rangeOfString:@"&city"];
    
    if (rangee.length == 0 && rangee.location == NSNotFound) {
        
        if([CLLocationManager locationServicesEnabled])
        {
            if ([range isEqualToString:@"不选择"] || [range isEqualToString:@"不限"]) {
                
                urlStr = [urlStr stringByAppendingFormat:@"&joblocation=%@",meLocation];
                
            } else {
                
                urlStr = [urlStr stringByAppendingFormat:@"&joblocation=%@&point_ranger=%@",meLocation,range];
            }
            
        } 
    }        
    
    NSLog(@"%@",urlStr);
    
    EncryptURL *encrpy = [[EncryptURL alloc]init];
    NSString *encrpyStr = [encrpy getMD5String:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  //如果需要对中文转码
    NSURL *url = [[NSURL alloc]initWithString:encrpyStr]; 
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    self.sourceConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [encrpy release];
    [url release];
    [request release];
}

- (void)getSourceData   //当接收完数据调用  解析XML数据
{
    
    self.jobArr = [[NSMutableArray alloc]init];  //初始化
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:self.sourceData options:0 error:nil];
    GDataXMLElement *root = [document rootElement];

    for(GDataXMLElement *position in [root nodesForXPath:@"result/position" error:nil])
    {
        NSString *jobNumber = [[[position nodesForXPath:@"job_number" error:nil]objectAtIndex:0]stringValue];
        NSString *jobName = [[[position nodesForXPath:@"job_title" error:nil]objectAtIndex:0]stringValue];
        NSString *companyNumber = [[[position nodesForXPath:@"company_number" error:nil]objectAtIndex:0]stringValue];
        NSString *companyName = [[[position nodesForXPath:@"company_name" error:nil]objectAtIndex:0]stringValue];
        NSString *city = [[[position nodesForXPath:@"city_id" error:nil]objectAtIndex:0]stringValue];
        NSString *date = [[[position nodesForXPath:@"date_opening" error:nil]objectAtIndex:0]stringValue];
        
        Job *job = [Job jobWitnName:jobName Number:jobNumber companyName:companyName companyNumber:companyNumber city:city date:date];
        [self.jobArr addObject:job];
        
    }
    
    [self.jobArr release];
    
    //NSLog(@"%@",[[NSString alloc]initWithData:self.sourceData encoding:NSUTF8StringEncoding]);
//    for(Job *job in self.jobArr)
//    {
//        NSLog(@"%@",job);
//    }
    
    //[Indicator removeIndicator:self.view];
    sourceDataTableView.delegate = self;
    sourceDataTableView.dataSource = self;
    [self initCellButtonIsSelectArr];  //cell的按钮
    [sourceDataTableView reloadData];

}

- (void)sendApplyPositionRequest:(NSString *)urlStr //申请职位
{
    EncryptURL *encrpy = [[EncryptURL alloc]init];
    NSString *encrpyStr = [encrpy getMD5String:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  //如果需要对中文转码
    NSURL *url = [[NSURL alloc]initWithString:encrpyStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    self.applyConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)getApplyPositionData   //解析申请职位返回的XML数据    
{
    NSLog(@"%@",[[NSString alloc]initWithData:self.applyPosition encoding:NSUTF8StringEncoding]);
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:self.applyPosition options:0 error:nil];
    GDataXMLElement *root = [document rootElement];
    
    NSString *message = [[[root nodesForXPath:@"message" error:nil]objectAtIndex:0]stringValue];  //返回的信息 
    
    //NSString *finish = [[[root nodesForXPath:@"finish" error:nil]objectAtIndex:0]stringValue]; //几个职位申请成功
    //NSString *setdefaultresume = [[[root nodesForXPath:@"setdefaultresume" error:nil]objectAtIndex:0]stringValue]; //设置默认简历是否成功
    
    //NSLog(@"%@ %@ %@",message,finish,setdefaultresume);
    
    if ([message isEqualToString:@"职位申请成功"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"职位申请成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"职位申请失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [alert release];
    }

}

- (void)sendPositionSearch:(NSString *)urlStr  //保存职位搜索器
{
    EncryptURL *encrpy = [[EncryptURL alloc]init];
    NSLog(@"%@",urlStr);
    NSString *encrpyStr = [encrpy getMD5String:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  //如果需要对中文转码
    NSURL *url = [[NSURL alloc]initWithString:encrpyStr]; 
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    self.positionConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [encrpy release];
    [url release];
    [request release];
}

- (void)getPositionSearchData   //解析保存职位搜索器返回的XML数据
{
    
    NSLog(@"%@",[[NSString alloc]initWithData:self.positionSearch encoding:NSUTF8StringEncoding]);
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:self.positionSearch options:0 error:nil];
    GDataXMLElement *element = [document rootElement];    
    
    if ([[[[element nodesForXPath:@"//message" error:nil]objectAtIndex:0]stringValue]isEqualToString:@"成功添加"])  //添加成功
    {  
        
        //[Prompt addPrompt:self.view text:@"添加成功"];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        self.label.text = [self.label.text isEqualToString:@"保存搜索器▼"] ? @"保存搜索器▲" : @"保存搜索器▼";
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [UIView setAnimationDidStopSelector:@selector(resetSearchBar)];
            [UIView setAnimationDelegate:self];
            
            self.changeRangeLabel.frame = CGRectMake(self.changeRangeLabel.frame.origin.x, self.changeRangeLabel.frame.origin.y - 175, self.changeRangeLabel.frame.size.width, self.changeRangeLabel.frame.size.height);
            
            self.changeRangeButton.frame = CGRectMake(self.changeRangeButton.frame.origin.x, self.changeRangeButton.frame.origin.y - 175, self.changeRangeButton.frame.size.width, self.changeRangeButton.frame.size.height);
            
            self.sourceDataTableView.frame = CGRectMake(self.sourceDataTableView.frame.origin.x, self.sourceDataTableView.frame.origin.y - 175, self.sourceDataTableView.frame.size.width, self.sourceDataTableView.frame.size.height);
            
            searchBarView.frame = CGRectMake(0, -175, 320, 175);
            
        }];
    } else {  //添加失败
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"添加失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        [alert release];
    }
    
}



#pragma mark 异步请求的代理方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response //收到请求响应
{
    if (connection == self.sourceConnection) {
        
        self.sourceData = [[NSMutableData alloc]init];
        [self.sourceData release];
        //NSLog(@"1 %s %d",__FUNCTION__,__LINE__);
        
    } else if( connection == self.applyConnection)
    {
        self.applyPosition = [[NSMutableData alloc]init];
        [self.applyPosition release];
        //NSLog(@"2 %s %d",__FUNCTION__,__LINE__);
        
    } else if(connection == self.positionConnection)
    {
        self.positionSearch = [[NSMutableData alloc]init];
        [self.positionSearch release];
        //NSLog(@"3 %s %d",__FUNCTION__,__LINE__);
        
    } 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  //开始接收数据
{
    if (connection == self.sourceConnection) {
        
        [self.sourceData appendData:data];        
        //NSLog(@"1 %s %d",__FUNCTION__,__LINE__);
        
    } else if( connection == self.applyConnection)
    {
        [self.applyPosition appendData:data];
        //NSLog(@"2 %s %d",__FUNCTION__,__LINE__);
    } else if(connection == self.positionConnection)
    {
        [self.positionSearch appendData:data];
        //NSLog(@"3 %s %d",__FUNCTION__,__LINE__);
        
    } 
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection   //数据接收完成
{
    
    if (connection == self.sourceConnection) {
        
        //[self performSelector:@selector(getSourceData) withObject:self afterDelay:3];
        [self getSourceData];      //解析XML数据
        //NSLog(@"1 %s %d",__FUNCTION__,__LINE__);
        
    } else if( connection == self.applyConnection)
    { 
        [self getApplyPositionData];  //解析XML数据
        
        //NSLog(@"2 %s %d",__FUNCTION__,__LINE__);
        
    } else if(connection == self.positionConnection)
    {
        [self getPositionSearchData];  //解析XML数据
        //NSLog(@"3 %s %d",__FUNCTION__,__LINE__);
    } 
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  //请求失败
{
    if (connection == self.sourceConnection) {
        
        [Indicator removeIndicator:self.view];
        NSLog(@"1 %s %d",__FUNCTION__,__LINE__);
        
    } else if(connection == self.positionConnection)
    {
        
        NSLog(@"3 %s %d",__FUNCTION__,__LINE__);
        
    }  else if( connection == self.applyConnection)
    {
        
        NSLog(@"2 %s %d",__FUNCTION__,__LINE__);
        
    } 
}


#pragma mark 警告框代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  //点击alert的按钮后
{
    if (alertView == self.signUpAlert) {
        
        if (buttonIndex ==1) {
            
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
            if ([[self.tabBarController.view.superview viewWithTag:2] isKindOfClass:[UIButton class]]) {
                
                UIButton *btn = (UIButton *)[self.tabBarController.view.superview viewWithTag:2];
                btn.selected = YES;
            }
            
            if ([[self.tabBarController.view.superview viewWithTag:1] isKindOfClass:[UIButton class]]) {
                
                UIButton *btn = (UIButton *)[self.tabBarController.view.superview viewWithTag:1];
                btn.selected = NO;
            }
        }
    }
    
}

#pragma mark pickerView的代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView  //几列
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component  //几行
{
    return [self.pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component  //每行的内容
{
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  //滚到某行后
{
    range = [self.pickerData objectAtIndex:row];
    //NSLog(@"%@",range);
    [changeRangeButton setTitle:[self.pickerData objectAtIndex:row] forState:UIControlStateNormal];
}

#pragma mark scrollView的代理方法


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView  //tableview开始滑动
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.changeRangeButton.userInteractionEnabled = YES;
        [self.changeRangeButton setTitle:self.range forState:UIControlStateNormal];
        self.toolBarAndPickerView.frame = CGRectMake(0, 460, 320, 30);
        self.picker.frame = CGRectMake(0, 490, 320, 100);
        
    }];
    
    if ([self.label.text isEqualToString:@"保存搜索器▲"]) {  //搜索器是否出现
        
        [self addSearchBar:nil];
    }

}

#pragma mark textField的代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField  //按return键后
{
    [self.searchBarName resignFirstResponder];
    return YES;
}

#pragma mark tableView的代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  //section的个数
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section //row的个数
{
    return [self.jobArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath //cell的高度
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  //设置cell的内容
{
    static NSString *Identifier = @"Cell";
    JobCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (cell == nil) {
        
        cell = [[[JobCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier]autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessoryArrow.png"]];
        [cell setAccessoryView:imageView];
        [imageView release];
    }
    
    Job *job = [self.jobArr objectAtIndex:indexPath.row];
    cell.jobNameLabel.text = job.name;
    cell.companyLabel.text = job.companyName;
    cell.dateLabel.text = job.date;
    cell.cityLabel.text = job.city;
    
    int isSelect = [[self.cellButtonIsSelectArr objectAtIndex:indexPath.row]intValue];
    cell.leftButton.selected = isSelect == -1 ? NO:YES;
    cell.leftButton.tag = indexPath.row;
//    UIImage *image1 = [UIImage imageNamed:@"search_result_unselected.png"];
//    UIImage *image2 = [UIImage imageNamed:@"search_result_selected.png"];
//    [cell.leftButton setBackgroundImage:image1 forState:UIControlStateNormal];
//    [cell.leftButton setBackgroundImage:image2 forState:UIControlStateSelected];
    [cell.leftButton addTarget:self action:@selector(changeImage:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  //选中cell
{
    NSLog(@"dsfdsfds");
    
    Job *job = [self.jobArr objectAtIndex:indexPath.row];
    NSString *jobNumber = job.number;
    NSString *companyNumber = job.companyNumber;
    NSLog(@"%@ %@",jobNumber,companyNumber);
    
    DetailView *detail = [[DetailView alloc]init];
    
    detail.comUrlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/company/showcompanydetail.aspx?Page=1&Pagesize=2&Company_number=%@",companyNumber];
    detail.jobUrlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/showjobdetail.aspx?Page=0&Pagesize=1&Job_number=%@",jobNumber];
    
    //[self presentModalViewController:detail animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
}




- (void)viewDidUnload
{
    [self setChangeRangeButton:nil];
    [self setSourceDataTableView:nil];
    [self setChangeRangeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
