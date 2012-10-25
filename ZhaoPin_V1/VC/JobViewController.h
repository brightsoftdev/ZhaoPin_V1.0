//
//  JobViewController.m
//  JobViewController
//
//  Created by 吴育星 on 12-10-10.



#import <UIKit/UIKit.h>

@interface JobViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSString *uticket; //身份标识
    NSString *jobbNumber;
}
@property(nonatomic,retain)NSMutableData *sourceData,*positionSearch,*applyPosition; //根据职位搜索取得的XML数据 职位搜索器 申请职位
@property(nonatomic,retain)NSURLConnection *sourceConnection,*positionConnection,*applyConnection; //职位搜索 职位搜索器 申请职位对应的异步请求
@property(nonatomic,retain)NSString *urlString,*positionSearchString;   //上个viewcontoller传过来的搜索条件url字符串  职位搜索器的文本
@property(nonatomic,retain)NSMutableArray *jobArr;  //职位的数组
@property(nonatomic,retain)NSString *range,*searchBar;  //公里范围
@property (retain, nonatomic) IBOutlet UIButton *changeRangeButton; //改变公里
@property (retain, nonatomic) IBOutlet UILabel *changeRangeLabel;
@property (retain, nonatomic) IBOutlet UITableView *sourceDataTableView;
@property(nonatomic,retain)UIPickerView *picker;
@property(nonatomic,retain)NSMutableArray *pickerData; //pickerview的数据源
@property(nonatomic,retain)UIView *toolBarAndPickerView;  //存放toolbar和完成按钮
@property(nonatomic,retain)NSMutableArray *cellButtonIsSelectArr;  //保存职位是否被选中
@property(nonatomic,retain)UILabel *label;  //显示保存搜索器
@property(nonatomic,retain)UITextField *searchBarName;  //搜索器输入框
@property(nonatomic,retain)UIView *searchBarView;  //搜索器显示的view
@property(nonatomic,retain)NSString *meLocation;   //当前位置经纬度
@property(nonatomic,retain)NSMutableArray *searchBarTxt; //搜索条件
@property(nonatomic,retain)UIAlertView *signUpAlert;  //当没登陆时弹出的警告框

@end
