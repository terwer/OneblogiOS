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
#import "TGMetaWeblogApi.h"
#import "TTTAttributedLabel.h"
#import "SelectBlogViewController.h"
#import "Config.h"

@interface LoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>

/**
 *  xmlrpcURL
 */
@property(nonatomic, strong) UITextField *baseURLField;
/**
 *  用户名
 */
@property(nonatomic, strong) UITextField *usernameField;
/**
 *  密码
 */
@property(nonatomic, strong) UITextField *passwordField;
/**
 *  是否启用JSON API
 */
@property(nonatomic, strong) UISwitch *apiTypeSwitch;
/**
 *  登陆按钮
 */
@property(nonatomic, strong) UIButton *loginButton;
/**
 *  提示框
 */
@property(nonatomic, strong) MBProgressHUD *HUD;
/**
 *  提示信息
 */
@property(nonatomic, strong) TTTAttributedLabel *messageInfo;

/**
 *  网址api博客类型尾巴
 */
@property(nonatomic, copy) NSString *footerPrefix;
/**
 *  网址尾巴api
 */
@property(nonatomic, copy) NSString *footerApi;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //判断登录状态
    ApiInfo *apiInfo = [Config getAuthoizedApiInfo];
    if (apiInfo) {
        NSLog(@"Current baseURL:%@ username:%@ password:%@", apiInfo.baseURL, apiInfo.username, apiInfo.password);
        //已经登录过，跳转到主界面，停止程序继续
        [Utils goToMainViewController];
        return;
    }

    //初始化导航栏
    self.navigationItem.title = @"登录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectBlog)];

    self.view.backgroundColor = [UIColor themeColor];

    //初始化视图和布局
    [self initSubviews];
    [self setLayout];

    // 默认为wordpress博客
    self.footerApi = @"xmlrpc.php";

}

- (void)viewDidAppear:(BOOL)animated {
    //加载登陆数据
    [self loadLoginInfo];
    NSLog(@"appeared");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 加载选择的数据

- (void)loadLoginInfo {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.footerApi = [def objectForKey:@"xmlrpcURLSuffix"];  // 后缀
    self.footerPrefix = [def objectForKey:@"xmlrpcURLPrefix"];  // 前缀
    self.usernameField.text = [def objectForKey:@"mw_username"];
    self.passwordField.text = [def objectForKey:@"mw_passwod"];
    //JSON API状态
    _apiTypeSwitch.on = [[def objectForKey:@"isJSONAPIEnable"] boolValue];

}

#pragma mark 选择博客类型

- (void)selectBlog {
    NSLog(@"选择博客。");
    SelectBlogViewController *selectBlogController = [[SelectBlogViewController alloc] init];


    [self.navigationController pushViewController:selectBlogController animated:YES];

}

#pragma mark - about subviews

- (void)initSubviews {
    _baseURLField = [UITextField new];
    _baseURLField.placeholder = @"博客地址";
    _baseURLField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _baseURLField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _baseURLField.keyboardType = UIKeyboardTypeEmailAddress;
    _baseURLField.delegate = self;
    _baseURLField.returnKeyType = UIReturnKeyNext;
    _baseURLField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _baseURLField.enablesReturnKeyAutomatically = YES;
    _baseURLField.text = @"https://rpc.cnblogs.com/metaweblog/tangyouwei";

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

    [self.view addSubview:_baseURLField];
    [self.view addSubview:_usernameField];
    [self.view addSubview:_passwordField];

    _apiTypeSwitch = [[UISwitch alloc] init];
    [_apiTypeSwitch addTarget:self action:@selector(doSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_apiTypeSwitch];

    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _loginButton.backgroundColor = [UIColor colorWithHex:0x428bd1];
    [_loginButton setCornerRadius:5];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginMyBlog) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];

    _messageInfo = [TTTAttributedLabel new];
    _messageInfo.delegate = self;
    _messageInfo.numberOfLines = 0;
    _messageInfo.lineBreakMode = NSLineBreakByWordWrapping;
    _messageInfo.backgroundColor = [UIColor themeColor];
    _messageInfo.font = [UIFont systemFontOfSize:12];
    NSString *info = @"温馨提示：您可以登录任何实现了XML-RPC MetaWeblog API接口的博客。目前已经支持并测试通过的博客：Wordpress、ZBlog、Cnblogs、OSChina、163、51CTO、Sina。\r由于MetaWeblog API接口的限制，暂时只能进行文章的显示、查看、新增、修改和删除。\r部分功能有些博客不支持，详情看这里。\r更多功能需要服务端API支持，详情查看：Wordpress JSON API。";
    _messageInfo.text = info;
    NSRange range1 = [info rangeOfString:@"XML-RPC MetaWeblog API"];
    _messageInfo.linkAttributes = @{
            (NSString *) kCTForegroundColorAttributeName: [UIColor colorWithHex:0x428bd1]
    };
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"https://en.wikipedia.org/wiki/MetaWeblog"] withRange:range1];
    NSRange range2 = [info rangeOfString:@"详情看这里"];
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"呜呜呜"] withRange:range2];
    http:
    [self.view addSubview:_messageInfo];
    NSRange range3 = [info rangeOfString:@"Wordpress JSON API"];
    [_messageInfo addLinkToURL:[NSURL URLWithString:@"http://git.oschina.net/terwergreen/gist/blob/master/wordpress-json-api-http-sample-data.md"] withRange:range3];
    [self.view addSubview:_messageInfo];

    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    //解决TTTAttributedLabel的代理方法didSelectLinkWithURL不触发的Bug 15-07-29 by terwer
    gesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gesture];
}


- (void)setLayout {
    UIImageView *url = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-url"]];
    url.contentMode = UIViewContentModeScaleAspectFill;

    UIImageView *email = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-email"]];
    email.contentMode = UIViewContentModeScaleAspectFill;

    UIImageView *password = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-password"]];
    password.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *tips = [[UILabel alloc] init];
    tips.font = [UIFont systemFontOfSize:14];
    tips.text = @"是否启用JSON API";

    [self.view addSubview:url];
    [self.view addSubview:email];
    [self.view addSubview:password];
    [self.view addSubview:tips];

    for (UIView *view in [self.view subviews]) {view.translatesAutoresizingMaskIntoConstraints = NO;}


    NSDictionary *views = NSDictionaryOfVariableBindings(url, email, password, tips, _baseURLField, _usernameField, _passwordField, _apiTypeSwitch, _loginButton, _messageInfo);

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[url(20)]-20-[email(20)]-20-[password(20)]-20-[tips(20)]-20-[_loginButton(40)]"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_loginButton]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton]-10-[_messageInfo]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-40-[url(20)]-[_baseURLField]-60-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-40-[email(20)]-[_usernameField]-60-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-40-[password(20)]-[_passwordField]-60-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-40-[tips(180)]-40-[_apiTypeSwitch]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}


#pragma mark - 键盘操作

- (void)hidenKeyboard {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)returnOnKeyboard:(UITextField *)sender {
    if (sender == _usernameField) {
        [_passwordField becomeFirstResponder];
    } else if (sender == _passwordField) {
        [self hidenKeyboard];
        if (_loginButton.enabled) {
            [self loginMyBlog];
        }
    }
}


#pragma mark 登录相关

//使用xmlrpcURL登录
- (void)loginMyBlog {
    NSString *baseURL = [_baseURLField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *username = [_usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [_passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    // 默认博客园
    _baseURLField.text = [NSString stringWithFormat:@"%@/%@", self.footerPrefix, self.footerApi];

    //登陆提示
    _HUD = [Utils createHUD];

    //登陆验证
    if ([baseURL isEqualToString:@""]) {
        _HUD.labelText = @"博客API地址不能为空！";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }

//    if ([baseURL hasPrefix:@"http"]) {
//        _HUD.labelText = @"博客地址勿带http";
//        _HUD.mode = MBProgressHUDModeCustomView;
//        _HUD.userInteractionEnabled = NO;
//        //隐藏提示
//        [_HUD hide:YES afterDelay:1];
//        return;
//    }

    if ([username isEqualToString:@""]) {
        _HUD.labelText = @"用户名不能为空！";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }

    if (username.length < 5 || username.length > 20) {
        _HUD.labelText = @"用户名只能在5-20之间！";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }

    if ([password isEqualToString:@""]) {
        _HUD.labelText = @"密码不能为空！";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }

    if (password.length < 5 || password.length > 20) {
        _HUD.labelText = @"密码只能在5-20之间！";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.userInteractionEnabled = NO;
        //隐藏提示
        [_HUD hide:YES afterDelay:1];
        return;
    }

    _HUD.labelText = @"正在登录";
    _HUD.userInteractionEnabled = NO;

    if (_apiTypeSwitch.on) {
        NSLog(@"JSON API");
        [self loginWithJOSNAPI:baseURL username:username password:password];
    } else {
        NSLog(@"XMLRPC API");
        //对baseUrl进行包装  暂时不支持Https
        KLog(@"url尾巴是%@", self.footerPrefix);
        if ([self.footerPrefix isEqualToString:KWordPress]) {
            //wordpress
            baseURL = [NSString stringWithFormat:@"http://%@/%@", baseURL, self.footerApi];
        } else if ([self.footerPrefix isEqualToString:KZBlog]) {
            // ZBlog
            baseURL = [NSString stringWithFormat:@"http://%@:8080/%@", baseURL, self.footerApi];
        } else if ([self.footerPrefix isEqualToString:KOtherBlog]) {
            baseURL = [NSString stringWithFormat:@"http://%@/%@", baseURL, self.footerApi];
        } else {
            // CnBlog 博客
            baseURL = [NSString stringWithFormat:@"%@/%@", self.footerPrefix, self.footerApi];
        }

        KLog(@"最后的地址是%@", baseURL);
        [self loginWithXmlrpc:baseURL username:username password:password];
    }
}

/**
 *  使用XMLRPC API登陆
 *
 *  @param baseURL  baseURL
 *  @param username username
 *  @param pasword  pasword
 */
- (void)loginWithXmlrpc:(NSString *)baseURL username:(NSString *)username password:(NSString *)pasword {
    //登录
    NSLog(@"current user :%@ %@ %@", baseURL, username, pasword);
    [TGMetaWeblogAuthApi signInWithURL:baseURL
                              username:username
                              password:pasword
                               success:^(NSURL *xmlrpcURL) {
                                   NSLog(@"登陆成功---success:%@", xmlrpcURL);
                                   NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                                   [def setObject:[xmlrpcURL absoluteString] forKey:@"baseURL"];
                                   [def setObject:self.usernameField.text forKey:@"mw_username"];
                                   [def setObject:self.passwordField.text forKey:@"mw_password"];
                                   [def synchronize];
                                   //隐藏提示
                                   [_HUD hide:YES afterDelay:1];
                                   //登录成功，跳转到主界面
                                   [Utils goToMainViewController];
                               }
                               failure:^(NSError *error) {
                                   _HUD.mode = MBProgressHUDModeCustomView;
                                   _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                   _HUD.labelText = [NSString stringWithFormat:@"错误：%@", [error localizedDescription]];
                                   [_HUD hide:YES afterDelay:1];
                               }];
}

/**
 *  使用JSON API登陆
 *
 *  @param baseURL  baseURL
 *  @param username username
 *  @param password password
 */
- (void)loginWithJOSNAPI:(NSString *)baseURL username:(NSString *)username password:(NSString *)password {

    NSString *requestURL = [NSString stringWithFormat:@"%@user/generate_auth_cookie/?username=%@&password=%@", baseURL, username, password];

    NSLog(@"login request URL:%@", requestURL);
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil
         success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 //刷新数据
                 //NSLog(@"JSON: %@", responseObject);
                 NSLog(@"status:%@", [result objectForKey:@"status"]);
                 NSString *status = [result objectForKey:@"status"];
                 if ([status isEqualToString:@"ok"]) {
                     NSString *cookie = result[@"cookie"];

                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                     [userDefaults setObject:cookie forKey:@"generate_auth_cookie"];
                     [userDefaults synchronize];

                     NSLog(@"JSON API login ok");

                     [_HUD hide:YES afterDelay:1];

                     //登陆成功，跳转到主界面
                     [Utils goToMainViewController];
                 } else {
                     NSLog(@"login error");
                     _HUD.mode = MBProgressHUDModeCustomView;
                     _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                     _HUD.labelText = [NSString stringWithFormat:@"错误：%@", result[@"error"]];
                     [_HUD hide:YES afterDelay:1];
                 }
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error login with json api: %@", [error localizedDescription]);
             _HUD.mode = MBProgressHUDModeCustomView;
             _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
             _HUD.labelText = [NSString stringWithFormat:@"错误：%@", [error localizedDescription]];
             [_HUD hide:YES afterDelay:1];

         }];
}

#pragma mark - 超链接代理

- (void)attributedLabel:(TTTAttributedLabel *)label didLongPressLinkWithURL:(NSURL *)url atPoint:(CGPoint)point {
    UIAlertController *confirmCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否使用Safari打开网页？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //调用Safari打开网页
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[url absoluteString]]];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [confirmCtl addAction:yesAction];
    [confirmCtl addAction:noAction];
    [self presentViewController:confirmCtl animated:YES completion:nil];
}

/**
 *  超链接单击
 *
 *  @param label label
 *  @param url   url
 */
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSLog(@"Selected url:%@", [url absoluteString]);
    NSString *title = @"What is MetaWeblog API?";
    if ([[url absoluteString] isEqualToString:@"http://git.oschina.net/terwergreen/gist/blob/master/wordpress-json-api-http-sample-data.md"]) {
        title = @"Wordpress JSON API";
    }
    [Utils navigateUrl:self withUrl:url andTitle:title];
}

/**
 *  切换API
 */
- (void)doSwitch {
    NSLog(@"开启JSON API");
    _baseURLField.text = @"";
    if (_apiTypeSwitch.on) {
        _baseURLField.placeholder = @"请输入JSON API入口地址";
    } else {
        _baseURLField.placeholder = @"请输入MetaWeblog API入口地址";
    }
}
@end
