//
//  LoginViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "LoginViewController.h"
#import "Utils.h"
#import "OBTabBarController.h"
#import "SideMenuViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "AppDelegate.h"
#import "Config.h"
#import "TGMetaWeblogApi.h"
#import "TTTAttributedLabel.h"
#import "BrowserNavViewController.h"
#import "BrowserViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,TTTAttributedLabelDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

/**
 *  xmlrpcURL
 */
@property(nonatomic, strong) UITextField *xmlrpcField;
/**
 *  用户名
 */
@property(nonatomic, strong) UITextField *usernameField;
/**
 *  密码
 */
@property(nonatomic, strong) UITextField *passwordField;
/**
 *  登陆按钮
 */
@property(nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) MBProgressHUD *HUD;
/**
 *  提示信息
 */
@property(nonatomic, strong) TTTAttributedLabel *messageInfo;

@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation LoginViewController

@synthesize pickerView = _pickerView,dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断登录状态
    ApiInfo *apiInfo = [Config getAuthoizedApiInfo];
    if(apiInfo){
        NSLog(@"Current xmprpc:%@ username:%@ password:%@",apiInfo.xmlrpc,apiInfo.username,apiInfo.password);
        //已经登录过，跳转到主界面，停止程序继续
        [self goToMainViewController];
        return;
    }
    
    //初始化导航栏
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor themeColor];
    
    //初始化视图和布局
    [self initSubviews];
    [self setLayout];
    
    //测试数据
    self.xmlrpcField.text = @"http://www.terwer.com/xmlrpc.php";
    self.usernameField.text = @"terwer";
    self.passwordField.text = @"cbgtyw2020";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - about subviews

- (void)initSubviews {
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
    
    _xmlrpcField = [UITextField new];
    _xmlrpcField.placeholder = @"Url";
    _xmlrpcField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _xmlrpcField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _xmlrpcField.keyboardType = UIKeyboardTypeEmailAddress;
    _xmlrpcField.delegate = self;
    _xmlrpcField.returnKeyType = UIReturnKeyNext;
    _xmlrpcField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _xmlrpcField.enablesReturnKeyAutomatically = YES;
    
    _usernameField = [UITextField new];
    _usernameField.placeholder = @"Username";
    _usernameField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usernameField.keyboardType = UIKeyboardTypeEmailAddress;
    _usernameField.delegate = self;
    _usernameField.returnKeyType = UIReturnKeyNext;
    _usernameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _usernameField.enablesReturnKeyAutomatically = YES;
    
    self.passwordField = [UITextField new];
    _passwordField.placeholder = @"Password";
    _passwordField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.enablesReturnKeyAutomatically = YES;
    
    [_usernameField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:_pickerView];
    [self.view addSubview:_xmlrpcField];
    [self.view addSubview:_usernameField];
    [self.view addSubview:_passwordField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _loginButton.backgroundColor = [UIColor colorWithHex:0x428bd1];
    [_loginButton setCornerRadius:5];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _messageInfo = [TTTAttributedLabel new];
    _messageInfo.delegate = self;
    _messageInfo.numberOfLines = 0;
    _messageInfo.lineBreakMode = NSLineBreakByWordWrapping;
    _messageInfo.backgroundColor = [UIColor themeColor];
    _messageInfo.font = [UIFont systemFontOfSize:14];
    NSString *info = @"温馨提示：您可以登录任何实现了XML-RPC MetaWeblog API接口的博客。目前已经支持并测试通过的博客：Wordpress、ZBlog、Cnblogs、OSChina、163、51CTO、Sina。\r由于MetaWeblog API接口的限制，暂时只能进行文章的显示、查看、新增、修改和删除。\r部分功能有些博客不支持，详情看这里。\r更多功能需要服务端API支持，详情查看：Wordpress JSON API。";
    _messageInfo.text = info;
    NSRange range1 = [info rangeOfString:@"XML-RPC MetaWeblog API"];
    _messageInfo.linkAttributes = @{
                                    (NSString *) kCTForegroundColorAttributeName : [UIColor colorWithHex:0x428bd1]
                                    };
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/MetaWeblog"] withRange:range1];
     NSRange range2 = [info rangeOfString:@"详情看这里"];
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://gist.github.com/terwer/7acc30a460e3ef671415"] withRange:range2];
    [self.view addSubview:_messageInfo];
    NSRange range3 = [info rangeOfString:@"Wordpress JSON API"];
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://gist.github.com/terwer/53a8da89bcec5c7d28bf"] withRange:range3];
    [self.view addSubview:_messageInfo];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    //解决TTTAttributedLabel的代理方法didSelectLinkWithURL不触发的Bug 15-07-29 by terwer
    gesture.cancelsTouchesInView=NO;
    [self.view addGestureRecognizer:gesture];
}

- (void)setLayout {
    UIImageView *url = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login-url"]];
    url.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *email = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-email"]];
    email.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *password = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-password"]];
    password.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:url];
    [self.view addSubview:email];
    [self.view addSubview:password];
    
    for (UIView *view in [self.view subviews]) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_pickerView,url,email, password,_xmlrpcField, _usernameField, _passwordField, _loginButton, _messageInfo,_messageInfo);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_pickerView]-0-[url(20)]-20-[email(20)]-20-[password(20)]-30-[_loginButton(40)]"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_loginButton]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton]-20-[_messageInfo(180)]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[url(20)]-[_xmlrpcField]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[email(20)]-[_usernameField]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[password(20)]-[_passwordField]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}


#pragma mark - 键盘操作

- (void)hidenKeyboard
{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender
{
    if (sender == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (sender == _passwordField) {
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            [self login];
        }
    }
}


#pragma mark 登录相关
//使用xmlrpcURL登录
- (void)login {
    //before login
    _HUD = [Utils createHUD];
    _HUD.labelText = @"正在登录";
    _HUD.userInteractionEnabled = NO;
    
    // Sign in
    [TGMetaWeblogAuthApi signInWithURL:self.xmlrpcField.text
                              username:self.usernameField.text
                              password:self.passwordField.text
                               success:^(NSURL *xmlrpcURL) {
                                   NSLog(@"success:%@",xmlrpcURL);
                                   NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                                   [def setObject:[xmlrpcURL absoluteString] forKey:@"mw_xmlrpc"];
                                   [def setObject:self.usernameField.text forKey:@"mw_username"];
                                   [def setObject:self.passwordField.text forKey:@"mw_password"];
                                   [def synchronize];
                                   //隐藏提示
                                   [_HUD hide:YES afterDelay:1];
                                   //登录成功，跳转到主界面
                                   [self goToMainViewController];
                               }
                               failure:^(NSError *error) {
                                   _HUD.mode = MBProgressHUDModeCustomView;
                                   _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                   _HUD.labelText = [NSString stringWithFormat:@"错误：%@", [error localizedDescription]];
                                   [_HUD hide:YES afterDelay:1];
                               }];
}

//跳转到主界面
-(void)goToMainViewController{
    OBTabBarController *tabBarController = [OBTabBarController new];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    tabBarController.delegate =(id<UITabBarControllerDelegate>) appDelegate ;
    
    RESideMenu *sideMenuTabBarViewController = [[RESideMenu alloc] initWithContentViewController:tabBarController
                                                                          leftMenuViewController:[SideMenuViewController new]
                                                                         rightMenuViewController:nil];
    
    //设置样式
    sideMenuTabBarViewController.scaleContentView = YES;
    sideMenuTabBarViewController.contentViewScaleValue = 0.95;
    sideMenuTabBarViewController.scaleMenuView = NO;
    sideMenuTabBarViewController.contentViewShadowEnabled = YES;
    sideMenuTabBarViewController.contentViewShadowRadius = 4.5;
    
    //设置根视图
    appDelegate.window.rootViewController = sideMenuTabBarViewController;
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
            _xmlrpcField.text = @"http://www.terwer.com/xmlrpc.php";
            break;
        case 1:
            NSLog(@"ZBlog");
            _xmlrpcField.text = @"http://www.terwer.com:8080/xmlrpc";
            break;
        case 2:
            NSLog(@"Cnblogs");
            _xmlrpcField.text = @"http://www.cnblogs.com/tangyouwei/services/metaweblog.aspx";
            break;
        case 3:
            NSLog(@"OSChina");
            _xmlrpcField.text =@"http://my.oschina.net/action/xmlrpc";
            break;
        case 4:
            NSLog(@"163");
            _xmlrpcField.text =@"http://os.blog.163.com/api/xmlrpc/metaweblog/";
            break;
        case 5:
            NSLog(@"51CTO");
            _xmlrpcField.text =@"http://terwer.blog.51cto.com/xmlrpc.php";
            break;
        case 6:
            NSLog(@"Sina");
            _xmlrpcField.text =@"http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php";
            break;
        default:
            NSLog(@"Other");
            _xmlrpcField.text = @"";
            break;
    }
}

#pragma mark - 超链接代理
-(void)attributedLabel:(TTTAttributedLabel *)label  didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point{
    UIAlertController *confirmCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否使用Safari打开网页？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]]; //调用Safari打开网页
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [confirmCtl addAction:yesAction];
    [confirmCtl addAction:noAction];
    [self presentViewController:confirmCtl animated:yesAction completion:nil];
}

/**
 *  超链接单击
 *
 *  @param label label
 *  @param url   url
 */
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Selected url:%@",[url absoluteString]);
    [Utils navigateUrl:self withUrl:url andTitle:@"What is MetaWeblog API?"];
}
@end
