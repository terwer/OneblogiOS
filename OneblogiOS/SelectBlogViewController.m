//
//  SelectBlogViewController.m
//  OneblogiOS
//
//  Created by szgxa30 on 15/8/5.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "SelectBlogViewController.h"
#import "Utils.h"
#import "Utils.h"

@interface SelectBlogViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

/**
 *  博客类型下拉框
 */
@property (nonatomic, strong) UIPickerView *pickerView;
/**
 *  选择博客类型数据
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 *  xmlrpc链接地址
 */
@property (nonatomic,strong) NSString *xmlrpcURL;
@end

@implementation SelectBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化导航栏
    self.navigationItem.title = @"选择博客";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doSelectBlog)];
    self.view.backgroundColor = [UIColor themeColor];
    
    //初始化视图和布局
    [self initSubviews];
    [self setLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) doSelectBlog{
    if (!_xmlrpcURL) {
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.detailsLabelText = @"请选择博客类型";
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        [HUD hide:YES afterDelay:1];
        return;
    }
    NSLog(@"选择了博客：　%@",_xmlrpcURL);
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:_xmlrpcURL forKey:@"baseURL"];
    [def synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initSubviews{
    // Init the data array.
    _dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
    [_dataArray addObject:@"请选择"];
    [_dataArray addObject:@"Wordpress"];
    [_dataArray addObject:@"ZBlog"];
    [_dataArray addObject:@"Cnblogs"];
    [_dataArray addObject:@"OSChina"];
    [_dataArray addObject:@"163"];
    [_dataArray addObject:@"51CTO"];
    [_dataArray addObject:@"Sina"];
    [_dataArray addObject:@"JSON API"];
    [_dataArray addObject:@"Other"];
    
    // Calculate the screen's width.
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth;
    
    // Calculate the starting x coordinate.
    float xPoint = screenWidth / 2 - pickerWidth / 2 - 30;
    
    // Init the picker view.
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(xPoint, 50.0f, pickerWidth, 50.0f)];
    
    // Set the delegate and datasource. Don't expect picker view to work
    // correctly if you don't set it.
    [_pickerView setDataSource: self];
    [_pickerView setDelegate: self];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    _pickerView.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    [self.view addSubview: _pickerView];
}

- (void)setLayout{
    
}


#pragma mark pickerView

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: %@", [_dataArray objectAtIndex: row]);
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:[NSString stringWithFormat:@"%d",NO] forKey:@"isJSONAPIEnable"];
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
            _xmlrpcURL =@"http://my.oschina.net/action/xmlrpc";
            break;
        case 5:
            NSLog(@"163");
            _xmlrpcURL =@"http://os.blog.163.com/api/xmlrpc/metaweblog/";
            break;
        case 6:
            NSLog(@"51CTO");
            _xmlrpcURL =@"http://terwer.blog.51cto.com/xmlrpc.php";
            break;
        case 7:
            NSLog(@"Sina");
            _xmlrpcURL =@"http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php";
            break;
        case 8:
        {
            NSLog(@"JSON API");
            _xmlrpcURL = @"http://www.terwer.com/api/";
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            [def setObject:[NSString stringWithFormat:@"%d",YES] forKey:@"isJSONAPIEnable"];
            [def synchronize];
            break;
        }
        default:
            NSLog(@"Other");
            _xmlrpcURL = @"";
            break;
    }
}

@end
