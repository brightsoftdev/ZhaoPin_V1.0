//
//  DetailView.m
//  DeV
//
//  Created by Ibokan on 12-10-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailView.h"
#import "EncryptURL.h"
#import "GDataXMLNode.h"
#import "AnotherJob.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Scale.h"

@implementation DetailView
@synthesize jobUrlStr,comUrlStr,com,jo;
@synthesize jobNumber,jobTitle;
@synthesize comNumber;
@synthesize appBtn,collectBtn,similarBtn,checkBtn;
@synthesize tab;
@synthesize uticket;

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [self performSelectorInBackground:@selector(linkCompany) withObject:self];
   [self  performSelector:@selector(linkJob) withObject:self];
    
    self.tab = [[UITabBar alloc]initWithFrame:CGRectMake(0, 410, 320, 42)];//创建tab，上面贴上申请职位，收藏职位，相似职位，查看地图四个按钮
    [tab setBackgroundImage:[[UIImage imageNamed:@"bottombar.png"]scaleToSize:CGSizeMake(320, 42)]];
    self.appBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    appBtn.frame = CGRectMake(0, 417, 80, 40);
    [appBtn setBackgroundImage:[UIImage imageNamed:@"joinjob.png"]  forState:UIControlStateNormal];
    [appBtn setBackgroundImage:[UIImage imageNamed:@"joinjob_s.png"] forState:UIControlStateHighlighted];
    [appBtn addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchUpInside];
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(80, 417, 80, 40);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"backupjob.png"]  forState:UIControlStateNormal];
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"backupjob_s.png"] forState:UIControlStateHighlighted];
    [collectBtn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    self.similarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    similarBtn.frame = CGRectMake(160, 417, 80, 40);
    [similarBtn setBackgroundImage:[UIImage imageNamed:@"samejob.png"]  forState:UIControlStateNormal];
    [similarBtn setBackgroundImage:[UIImage imageNamed:@"samejob_s.png"] forState:UIControlStateHighlighted];
    [similarBtn addTarget:self action:@selector(similar) forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(240, 417, 80, 40);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"map.png"]  forState:UIControlStateNormal];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"map_s.png"] forState:UIControlStateHighlighted];
    [checkBtn addTarget:self action:@selector(check) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarController.view.superview addSubview:tab];
    [self.tabBarController.view.superview addSubview:appBtn];
    [self.tabBarController.view.superview addSubview:checkBtn];
    [self.tabBarController.view.superview addSubview:collectBtn];
    [self.tabBarController.view.superview addSubview:similarBtn];
    
    [self.tab release];
    
    
    self.navigationItem.title = @"职位信息";
}

- (void)comView //点击公司介绍时加载以下数据
{
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)]autorelease];
    jobBut = [UIButton buttonWithType:UIButtonTypeCustom];//创建职位介绍按钮
    jobBut.frame = CGRectMake(0, 0, 160, 40);
    [jobBut setBackgroundImage:[UIImage imageNamed:@"jobDescSelected.png"] forState:UIControlStateNormal];
    [jobBut addTarget:self action:@selector(job) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jobBut];
    comBut = [UIButton buttonWithType:UIButtonTypeCustom];//创建公司介绍按钮
    comBut.frame = CGRectMake(160, 0, 160, 40);
    [comBut setBackgroundImage:[UIImage imageNamed:@"companyDescNormal.png"] forState:UIControlStateNormal];
    [comBut addTarget:self action:@selector(company) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comBut];
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, 320, 290)];//公司名称，类别，规模，行业，地址Label都创建于TextView上面
    UILabel *comNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 20)];
    comNameL.text = @"公司名称";
    comNameL.text = com.comName;
    comNameL.textColor = [UIColor orangeColor];
    NSString *classStr = [NSString stringWithFormat:@"类别：%@",com.classL];
    UILabel *classL = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 300, 18)];
    classL.text = classStr;
    [classL setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *scaleStr = [NSString stringWithFormat:@"规模：%@",com.scale];
    UILabel *scaleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 300, 18)];
    scaleL.text = scaleStr;
    [scaleL setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *industryStr = [NSString stringWithFormat:@"行业：%@",com.industry];
    UILabel *industryL = [[UILabel alloc]initWithFrame:CGRectMake(10, 72, 300, 18)];
    industryL.text = industryStr;
    [industryL  setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *adressStr = [NSString stringWithFormat:@"地址：%@",com.adress];//四十五个字以内
    UIFont *fontOne = [UIFont systemFontOfSize:15.0];
    CGSize maximumLabelSizeOne = CGSizeMake(310,MAXFLOAT);//310为我需要的UILabel的长度
    CGSize expectedLabelSizeOne = [adressStr sizeWithFont:fontOne
                               constrainedToSize:maximumLabelSizeOne
                                   lineBreakMode:UILineBreakModeWordWrap]; //expectedLabelSizeOne.height 就是内容的高度
    //初始化UILabel
    CGRect pointValueRect = CGRectMake(10, 92 ,310, expectedLabelSizeOne.height);
    UILabel *adressL = [[UILabel alloc] initWithFrame:pointValueRect];
    adressL.lineBreakMode = UILineBreakModeWordWrap;
    adressL.numberOfLines = 0;//上面两行设置多行显示
    [adressL setFont:[UIFont fontWithName:@"Arial" size:12]];
    adressL.text = adressStr;
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(5, 128, 310, 1)];
    line.image = [UIImage imageNamed:@"searchHistoryUpLine.png"];
    NSString *detailStr = [[[NSString alloc]init]autorelease];
    textV.editable = NO;//TextView不可输入
       for (int i = 0; i < 9; i++) {
        detailStr = [detailStr stringByAppendingString:@"\n"];//TextView上半部分显示信息会与Label重叠，输入回车让其跳转
    }
    if (com.details == nil) {
        textV.text = [detailStr stringByAppendingFormat:@"数据加载失败"];
    }
    else{
        textV.text = [detailStr stringByAppendingString:com.details]; 
    }
    [textV addSubview:comNameL];
    [textV addSubview:classL];
    [textV addSubview:scaleL];
    [textV addSubview:industryL];
    [textV addSubview:adressL];
    [textV addSubview:line];
    [comNameL release];
    [classL release];
    [scaleL release];
    [adressL release];
    [industryL release];
    [line release];
    UIImageView *lineToTableV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 330, 320, 1)];
    lineToTableV.image = [UIImage imageNamed:@"searchHistoryUpLine.png"];
    [self.view addSubview:lineToTableV];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 331, 320, 39)];//创建底部TableView
    table.scrollEnabled = NO;//tablleView不能滚动
    [table setDataSource:self];
    [table setDelegate:self];

    [self.view addSubview:table];
    [self.view addSubview:textV];
    [textV release];
    [lineToTableV release];
    [table release];
    //[tab release];

}


-(void)passByValueAndInitGeocoder//初始化Geocoder和属性传 “公司的名字和招聘的职位的名称”的值
{
    mapViewC = [[MapViewController alloc]init];
    
    CLGeocoder* geocoder1 = [[CLGeocoder alloc] init];
    // NSString *str=[NSString stringWithFormat:@"北京市石景山石景山路42号石景山区总工会"];
    NSString *str=com.adress;
    mapViewC.endPoint=str;
    
    //将汉字地址转换成coordinate（经纬度）
    [geocoder1 geocodeAddressString:str completionHandler:^(NSArray *placemarks, NSError *error){
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        coordinate1=placemark.location.coordinate;
        mapViewC.fromecorrdinate = coordinate1;
        //NSLog(@"  %f, 11 %f",coordinate1.latitude,coordinate1.longitude);
        
    }];
    
    mapViewC.jobAddress = com.comName;
    mapViewC.jobName = jo.jobName;
    //NSLog(@"%@",mapViewC.jobAddress);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)]autorelease];
    istouchButton = NO;
    jobBut = [UIButton buttonWithType:UIButtonTypeCustom];//创建职位介绍按钮
    jobBut.frame = CGRectMake(0, 0, 160, 40);
    [jobBut setBackgroundImage:[UIImage imageNamed:@"jobDescSelected.png"] forState:UIControlStateNormal];
    [jobBut addTarget:self action:@selector(job) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jobBut];
    comBut = [UIButton buttonWithType:UIButtonTypeCustom];//创建公司介绍按钮
    comBut.frame = CGRectMake(160, 0, 160, 40);
    [comBut setBackgroundImage:[UIImage imageNamed:@"companyDescNormal.png"] forState:UIControlStateNormal];
    [comBut addTarget:self action:@selector(company) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comBut];
   
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(0, 40, 320, 290)];//职位名称，月薪，地点，经验人数Label都创建于TextView上面
    
    
    UILabel *jobNameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
    jobNameL.text = jo.jobName ? jo.jobName :@"职位名称"; 
    jobNameL.textColor = [UIColor orangeColor];
    NSString *payStr = [NSString stringWithFormat:@"月薪：%@",jo.pay];
    UILabel *payL = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, 300, 18)];
    payL.text = payStr;
    [payL setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *placeStr = [NSString stringWithFormat:@"地点：%@",jo.adress];
    UILabel *placeL = [[UILabel alloc]initWithFrame:CGRectMake(10, 52, 300, 18)];
    placeL.text = placeStr;
    [placeL setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *experienceStr = [NSString stringWithFormat:@"经验：%@",jo.experience];
    UILabel *experienceL = [[UILabel alloc]initWithFrame:CGRectMake(10, 72, 300, 18)];
    experienceL.text = experienceStr;
    [experienceL setFont:[UIFont fontWithName:@"Arial" size:12]];
    NSString *numStr = [NSString stringWithFormat:@"人数：%@",jo.number];
    UILabel *numberL = [[UILabel alloc]initWithFrame:CGRectMake(10, 92, 300, 18)];
    numberL.text = numStr;
    [numberL setFont:[UIFont fontWithName:@"Arial" size:12]];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 120, 300, 1)];//TextView上的横线
    line.image = [UIImage imageNamed:@"searchHistoryUpLine.png"];//创建职位名称，月薪，地点，经验人数Label
    textV.editable = NO;//TextView不可输入
    
    
    NSString *detailStr = [[[NSString alloc]init]autorelease];
    for (int i = 0; i < 9; i++) {
        detailStr = [detailStr stringByAppendingString:@"\n"];//TextView上半部分显示信息会与Label重叠，输入回车让其跳转
    }
    if (jo.details == nil) {
        textV.text = [detailStr stringByAppendingFormat:@"加载失败"];
    }
    else{
        textV.text = [detailStr stringByAppendingFormat:@"%@",jo.details];
    }
    
    
    [textV addSubview:numberL];
    [textV addSubview:placeL];
    [textV addSubview:experienceL];
    [textV addSubview:jobNameL];
    [textV addSubview:payL];
    [textV addSubview:line];
    [numberL release];
    [experienceL release];
    [placeL release];
    [payL release];
    [jobNameL release];
    [line release];
    
    UIImageView *lineToTableV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 330, 320, 1)];//TextView中间横线为图片
    lineToTableV.image = [UIImage imageNamed:@"searchHistoryUpLine.png"];
    [self.view addSubview:lineToTableV];
    
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 331, 320, 39)];//创建底部TableView
    table.scrollEnabled = NO;//tablleView不能滚动
    [table setDataSource:self];
    [table setDelegate:self];
    

    
    [self.view addSubview:table];
    [self.view addSubview:textV];
    


    [textV release];
    [lineToTableV release];
    [table release];
    
    NSLog(@"%s %d",__FUNCTION__,__LINE__);

}
- (void)linkCompany
{

    EncryptURL *newUrl = [[EncryptURL alloc]init];
    
    NSURL *nowUrl = [NSURL URLWithString:[newUrl getMD5String:self.comUrlStr]];
    NSString *str = [NSString stringWithContentsOfURL:nowUrl encoding:NSUTF8StringEncoding error:nil];

    NSLog(@"%@",str);
    
    com = [[Company alloc]init];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:str options:0 error:nil];
    GDataXMLElement *root = [document rootElement];//获得根节点
    com.comName = [[[root nodesForXPath:@"//company_name" error:nil]objectAtIndex:0]stringValue];
    com.classL = [[[root nodesForXPath:@"//company_property" error:nil]objectAtIndex:0]stringValue];
    com.scale = [[[root nodesForXPath:@"//company_size" error:nil]objectAtIndex:0]stringValue];
    com.industry = [[[root nodesForXPath:@"//industry" error:nil]objectAtIndex:0]stringValue];
    com.adress = [[[root nodesForXPath:@"//address" error:nil]objectAtIndex:0]stringValue];
    com.details = [[[root nodesForXPath:@"//company_desc" error:nil]objectAtIndex:0]stringValue];
    self.comNumber = [[[root nodesForXPath:@"//company_number" error:nil]objectAtIndex:0]stringValue];
    
    self.jobTitle = [[[NSMutableArray alloc]init]autorelease];
    self.jobNumber = [[[NSMutableArray alloc]init]autorelease];
    
    for(GDataXMLElement *element in [root nodesForXPath:@"//job_number" error:nil])
    {
        [self.jobNumber addObject:[element stringValue]];
    }
    
    for (GDataXMLElement *element in [root nodesForXPath:@"//job_title" error:nil]) {
        
        [self.jobTitle addObject:[element stringValue]];
    }
    
    NSLog(@"%@ %@",self.jobTitle,self.jobNumber);
    
    [document release];
    
    [self passByValueAndInitGeocoder];

}
- (void)linkJob
{
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    EncryptURL *newUrl = [[EncryptURL alloc]init];
    NSURL *nowUrl = [NSURL URLWithString:[newUrl getMD5String:self.jobUrlStr]];
    NSString *str = [NSString stringWithContentsOfURL:nowUrl encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@",str);
    jo = [[DetailJob alloc]init];
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithXMLString:str options:0 error:nil];
    GDataXMLElement *root = [document rootElement];//获得根节点
    
    number = [[NSString alloc]init];
    number = [[[root nodesForXPath:@"currentjob/job_number" error:nil]objectAtIndex:0]stringValue];
    jo.jobName = [[[root nodesForXPath:@"currentjob/job_title" error:nil]objectAtIndex:0]stringValue];
    jo.pay = [[[root nodesForXPath:@"currentjob/salary_range" error:nil]objectAtIndex:0]stringValue];
    jo.adress = [[[root nodesForXPath:@"currentjob/job_city" error:nil]objectAtIndex:0]stringValue];
    jo.experience = [[[root nodesForXPath:@"currentjob/working_exp" error:nil]objectAtIndex:0]stringValue];
    jo.number = [[[root nodesForXPath:@"currentjob/number" error:nil]objectAtIndex:0]stringValue];
    jo.details = [[[root nodesForXPath:@"currentjob/responsibilty" error:nil]objectAtIndex:0]stringValue];
}

- (void)apply
{

    
    if (self.uticket == nil) {  //是否登陆
        
        aalert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您还未登陆,无法提交简历" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"登陆", nil];
        [aalert show];
        
    } else {
        
        NSLog(@"ttt%@",number);

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
        
        NSString *urlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/batchaddposition.aspx?uticket=%@&Resume_id=%@&Resume_number=%@&Version_number=%d&Job_number=%@&needSetDefResume=1",uticket,resume_id,resume_number,6,number];
        NSLog(@"%@",urlStr);
        
        NSString *encrpyStr = [e getMD5String:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  //如果需要对中文转码
        NSURL *url = [[NSURL alloc]initWithString:encrpyStr];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        apply = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}
- (void)collect
{

    if (self.uticket == nil) {  //是否登陆
        
        aalert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您还未登陆,无法提交简历" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"登陆", nil];
        [aalert show];
        
    } else {
        
        EncryptURL *e = [[EncryptURL alloc]init];
        
        collection =  [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[e getMD5String:[NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/collectposition.aspx?uticket=%@&Job_number=%@",uticket,number]]]] delegate:self];
        [e release];
    }
}
- (void)similar
{
    
}

- (void)check
{
   
    //mapViewC.fromecorrdinate=coordinate1;
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:@"cube"];//私有API 会被拒的
    //  [animation setSubtype:kCATransitionFromTop];
    
    [animation setSubtype:@"endProgress"];
    
    
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    
    [self.navigationController pushViewController:mapViewC animated:NO];
    
}

- (void)job//职位介绍按钮
{
    if (istouchButton == YES) {
        [self viewDidLoad];
        istouchButton = NO;
        [comBut setBackgroundImage:[UIImage imageNamed:@"companyDescNormal.png"] forState:UIControlStateNormal];
        [jobBut setBackgroundImage:[UIImage imageNamed:@"jobDescSelected.png"] forState:UIControlStateNormal];
    }
}
- (void) company//公司介绍按钮
{
    if (istouchButton == NO) {
        [self performSelector:@selector(comView)];
        istouchButton = YES;
        [comBut setBackgroundImage:[UIImage imageNamed:@"companyDescSelected.png"] forState:UIControlStateNormal];
        [jobBut setBackgroundImage:[UIImage imageNamed:@"jobDescNormal.png"] forState:UIControlStateNormal];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
    cell.textLabel.text = @"该公司其他职位";
    UIImageView *imagV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessoryArrow.png"]];
    cell.accessoryView = imagV;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnotherJob *anotherJobView = [[AnotherJob alloc]init];
    
    NSLog(@"%@",self.comNumber);
    
    anotherJobView.jobName = self.jobTitle;
    anotherJobView.jobNumber = self.jobNumber;
    anotherJobView.number = self.comNumber;
    
    [self.navigationController pushViewController:anotherJobView animated:YES];
    
    NSLog(@"touch it");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
    
    [appBtn setHidden:NO];
    collectBtn.hidden = NO;
    similarBtn.hidden = NO;
    checkBtn.hidden = NO;
    tab.hidden = NO;
    
    
    NSString *uticketPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"uticket.txt"];
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:uticketPath]) {
        
        self.uticket = [NSString stringWithContentsOfFile:uticketPath encoding:NSUTF8StringEncoding error:nil];
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [appBtn setHidden:YES];
    collectBtn.hidden = YES;
    similarBtn.hidden = YES;
    checkBtn.hidden = YES;
    tab.hidden = YES;
    
    
    NSLog(@"%s %d",__FUNCTION__,__LINE__);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == apply) {
        
        [applyData appendData:data];
    }
    
    if (connection == collection) {
        
        [collectionData appendData:data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (connection == apply) {
        
        applyData = [[NSMutableData alloc]init];
        
    }
    
    if (connection == collection) {
        
        collectionData = [[NSMutableData alloc]init];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == apply) {
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:applyData options:0 error:nil];
        GDataXMLElement *element = [document rootElement];
        NSString *str = [[[element nodesForXPath:@"//message" error:nil]objectAtIndex:0]stringValue];
        
        if ([str isEqualToString:@"职位申请成功"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"职位申请成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"职位申请失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
    
    if (connection == collection) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:collectionData encoding:NSUTF8StringEncoding]);
        
        GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithData:collectionData options:0 error:nil];
        
        NSString *str = [[[[document rootElement] nodesForXPath:@"//message" error:nil]objectAtIndex:0]stringValue];
        
        if ([str isEqualToString:@"收藏成功"]) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"收藏失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc
{
    [aalert release];
    aalert = nil;
    [apply release];
    apply = nil;
    [applyData release];
    applyData = nil;
    [collection release];
    collection = nil;
    [collectionData release];
    collectionData = nil;

    self.uticket = nil;
    [number release];
    number = nil;
    self.similarBtn = nil;
    self.appBtn = nil;
    self.collectBtn = nil;
    self.tab = nil;
    self.checkBtn = nil;
    
    self.comNumber = nil;
    [mapViewC release];
    mapViewC = nil;
    self.jobTitle = nil;
    self.jobNumber = nil;
    self.com = nil;
    comUrlStr = nil;
    jobUrlStr = nil;
    [super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
