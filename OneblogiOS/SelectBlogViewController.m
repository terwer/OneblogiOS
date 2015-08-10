//
//  SelectBlogViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/5.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "SelectBlogViewController.h"
#import "Utils.h"

@interface SelectBlogViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

/**
*  博客类型下拉框
*/
@property(nonatomic, strong) UIPickerView *pickerView;
/**
*  选择博客类型数据
*/
@property(nonatomic, strong) NSMutableArray *blogTypeArray;
/**
*  xmlrpc链接地址
*/
@property(nonatomic, strong) NSString *xmlrpcURL;
@end

@implementation SelectBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化导航栏
    self.navigationItem.title = @"选择博客";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doSelectBlog)];
    self.view.backgroundColor = [UIColor themeColor];

    //初始化视图和布局
    [self initSubviews];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  选中博客类型处理
 */
- (void)doSelectBlog {
    if (!_xmlrpcURL) {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.detailsLabelText = @"请选择博客类型";
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        [HUD hide:YES afterDelay:1];
        return;
    }
    NSLog(@"选择了博客：　%@", _xmlrpcURL);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:_xmlrpcURL forKey:@"baseURL"];
    [def synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews {
    //计算位置
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth;
    float xPoint = screenWidth / 2 - pickerWidth / 2 - 30;
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(xPoint, 50.0f, pickerWidth, 50.0f)];

    //设置代理
    [_pickerView setDataSource:self];
    [_pickerView setDelegate:self];

    //设置样式
    _pickerView.showsSelectionIndicator = YES;
    [_pickerView selectRow:0 inComponent:0 animated:YES];

    //添加控件
    [self.view addSubview:_pickerView];
}

- (void)setLayout {

}


#pragma mark pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.blogTypeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.blogTypeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"You selected this: %@", self.blogTypeArray[row]);

    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%d", NO] forKey:@"isJSONAPIEnable"];
    [def synchronize];

    switch (row) {
        case 1:
            NSLog(@"Wordpress");
            _xmlrpcURL = @"http://www.terwer.com/xmlrpc.php";
            break;
        case 2:
            NSLog(@"ZBlog");
            _xmlrpcURL = @"http://www.terwer.com:8080/xmlrpc";
            break;
        case 3:
            NSLog(@"Cnblogs");
            _xmlrpcURL = @"http://www.cnblogs.com/tangyouwei/services/metaweblog.aspx";
            break;
        case 4:
            NSLog(@"OSChina");
            _xmlrpcURL = @"http://my.oschina.net/action/xmlrpc";
            break;
        case 5:
            NSLog(@"163");
            _xmlrpcURL = @"http://os.blog.163.com/api/xmlrpc/metaweblog/";
            break;
        case 6:
            NSLog(@"51CTO");
            _xmlrpcURL = @"http://terwer.blog.51cto.com/xmlrpc.php";
            break;
        case 7:
            NSLog(@"Sina");
            _xmlrpcURL = @"http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php";
            break;
        case 8: {
            NSLog(@"JSON API");
            _xmlrpcURL = @"http://www.terwer.com/api/";
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:[NSString stringWithFormat:@"%d", YES] forKey:@"isJSONAPIEnable"];
            [def synchronize];
            break;
        }
            
        default:
            NSLog(@"Other");
            _xmlrpcURL = @"";
            break;
    }
}

/**
*  博客类型数据源懒加载
*
*  @return 博客数据源数组
*/
- (NSArray *)blogTypeArray {
    //初始化添加博客类型数据源
    if (!_blogTypeArray) {
        NSArray *tempArray = @[@"请选择", @"Wordpress", @"ZBlog", @"Cnblogs", @"OSChina", @"163", @"51CTO", @"Sina", @"JSON API", @"Other"];
        _blogTypeArray = [NSMutableArray arrayWithArray:tempArray];
    }
    return _blogTypeArray;
}

@end
