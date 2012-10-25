//
//  AnotherJob.m
//  Search
//
//  Created by Ibokan on 12-10-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnotherJob.h"
#import "DetailView.h"
#import "UIImage+Scale.h"


@implementation AnotherJob

@synthesize jobNumber,jobName;

@synthesize number;


- (void)dealloc {
    
    self.number = nil;
    self.jobName = nil;
    self.jobNumber = nil;
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"setting-form-back-button"]scaleToSize:CGSizeMake(30, 35)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [backItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"setting-form-back-button-click"]scaleToSize:CGSizeMake(30, 35)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = @"该公司其他职位";
}


#pragma mark tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.jobName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setAccessoryView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessoryArrow"]]];
    }
    
    cell.textLabel.text = [self.jobName objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailView *detailView = [[DetailView alloc]init];

    
    detailView.comUrlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/company/showcompanydetail.aspx?Page=1&Pagesize=2&Company_number=%@",self.number];
    
    
    detailView.jobUrlStr = [NSString stringWithFormat:@"http://wapinterface.zhaopin.com/iphone/job/showjobdetail.aspx?Page=0&Pagesize=1&Job_number=%@",[jobNumber objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detailView animated:YES];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
