//
//  SelectBlogViewController.m
//  OneblogiOS
//
//  Created by szgxa30 on 15/8/5.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "SelectBlogViewController.h"
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


@end

@implementation SelectBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化导航栏
    self.navigationItem.title = @"选择博客";
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

- (void)initSubviews{
    // Init the data array.
    _dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
    [_dataArray addObject:@"Wordpress"];
    [_dataArray addObject:@"ZBlog"];
    [_dataArray addObject:@"Cnblogs"];
    [_dataArray addObject:@"OSChina"];
    [_dataArray addObject:@"163"];
    [_dataArray addObject:@"51CTO"];
    [_dataArray addObject:@"Sina"];
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
    switch (row) {
        case 0:
            NSLog(@"Wordpress");
            //_xmlrpcField.text = @"http://www.terwer.com/xmlrpc.php";
            break;
        case 1:
            NSLog(@"ZBlog");
            //_xmlrpcField.text = @"http://www.terwer.com:8080/xmlrpc";
            break;
        case 2:
            NSLog(@"Cnblogs");
            //_xmlrpcField.text = @"http://www.cnblogs.com/tangyouwei/services/metaweblog.aspx";
            break;
        case 3:
            NSLog(@"OSChina");
            //_xmlrpcField.text =@"http://my.oschina.net/action/xmlrpc";
            break;
        case 4:
            NSLog(@"163");
           // _xmlrpcField.text =@"http://os.blog.163.com/api/xmlrpc/metaweblog/";
            break;
        case 5:
            NSLog(@"51CTO");
           // _xmlrpcField.text =@"http://terwer.blog.51cto.com/xmlrpc.php";
            break;
        case 6:
            NSLog(@"Sina");
           // _xmlrpcField.text =@"http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php";
            break;
        default:
            NSLog(@"Other");
           // _xmlrpcField.text = @"";
            break;
    }
}

@end
