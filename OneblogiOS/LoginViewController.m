//
//  LoginViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "LoginViewController.h"
#import <TTTAttributedLabel.h>
#import "Utils.h"
#import "OBTabBarController.h"
#import "SideMenuViewController.h"
#import <RESideMenu/RESideMenu.h>
#import "AppDelegate.h"
#import "Config.h"
#import "TGMetaWeblogApi.h"

@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,TTTAttributedLabelDelegate>

/**
 *  xmlrpcURL
 */
@property(nonatomic, strong) UITextField *xmlrpcField;
/**
 *  用户名
 */
@property(nonatomic, strong) UITextField *accountField;
/**
 *  密码
 */
@property(nonatomic, strong) UITextField *passwordField;
/**
 *  登陆按钮
 */
@property(nonatomic, strong) UIButton *loginButton;

/**
 *  提示信息
 */
@property(nonatomic, strong) TTTAttributedLabel *registerInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断登录状态
    if([Config getAuthoizedApiInfo]){
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - about subviews

- (void)initSubviews {
    _accountField = [UITextField new];
    _accountField.placeholder = @"Email";
    _accountField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _accountField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _accountField.keyboardType = UIKeyboardTypeEmailAddress;
    _accountField.delegate = self;
    _accountField.returnKeyType = UIReturnKeyNext;
    _accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountField.enablesReturnKeyAutomatically = YES;
    
    self.passwordField = [UITextField new];
    _passwordField.placeholder = @"Password";
    _passwordField.textColor = [UIColor colorWithRed:56.0f / 255.0f green:84.0f / 255.0f blue:135.0f / 255.0f alpha:1.0f];
    _passwordField.secureTextEntry = YES;
    _passwordField.delegate = self;
    _passwordField.returnKeyType = UIReturnKeyDone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.enablesReturnKeyAutomatically = YES;
    
    [_accountField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(returnOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.view addSubview:_accountField];
    [self.view addSubview:_passwordField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _loginButton.backgroundColor = [UIColor colorWithHex:0x15A230];
    [_loginButton setCornerRadius:20];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    _registerInfo = [TTTAttributedLabel new];
    _registerInfo.delegate = self;
    _registerInfo.numberOfLines = 0;
    _registerInfo.lineBreakMode = NSLineBreakByWordWrapping;
    _registerInfo.backgroundColor = [UIColor themeColor];
    _registerInfo.font = [UIFont systemFontOfSize:14];
    NSString *info = @"您可以在 https://www.oschina.net 上免费注册账号";
    _registerInfo.text = info;
    NSRange range = [info rangeOfString:@"https://www.oschina.net"];
    _registerInfo.linkAttributes = @{
                                     (NSString *) kCTForegroundColorAttributeName : [UIColor colorWithHex:0x15A230]
                                     };
    [_registerInfo addLinkToURL:[NSURL URLWithString:@"https://www.oschina.net/home/reg"] withRange:range];
    [self.view addSubview:_registerInfo];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
}

- (void)setLayout {
    UIImageView *email = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-email"]];
    email.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *password = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login-password"]];
    password.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:email];
    [self.view addSubview:password];
    
    for (UIView *view in [self.view subviews]) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    NSDictionary *views = NSDictionaryOfVariableBindings(email, password, _accountField, _passwordField, _loginButton, _registerInfo);
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                             toItem:_loginButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[email(20)]-20-[password(20)]-30-[_loginButton(40)]"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_loginButton]-20-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_loginButton]-20-[_registerInfo(30)]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[email(20)]-[_accountField]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-30-[password(20)]-[_passwordField]-30-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}

#pragma mark 键盘处理相关
- (void)returnOnKeyboard:(id)sender {
    
}

- (void)hidenKeyboard {
    
}

#pragma mark 登录相关
//使用xmlrpcURL登录
- (void)login {
    // Sign in
    [TGMetaWeblogAuthApi signInWithURL:self.xmlrpcField.text
                              username:self.accountField.text
                              password:self.passwordField.text
                               success:^(NSURL *xmlrpcURL) {
                                   NSLog(@"success:%@",xmlrpcURL);
                                   NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                                   [def setObject:[xmlrpcURL absoluteString] forKey:@"mw_xmlrpc"];
                                   [def setObject:self.accountField.text forKey:@"mw_username"];
                                   [def setObject:self.passwordField.text forKey:@"mw_password"];
                                   [def synchronize];
                                   //登录成功，跳转到主界面
                                   [self goToMainViewController];
                               }
                               failure:^(NSError *error) {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                   [alert show];
                               }];
}

//跳转到注解面
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
    appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    appDelegate.window.rootViewController = sideMenuTabBarViewController;
    [appDelegate.window makeKeyAndVisible];
    
    
    /************ 控件外观设置 **************/
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x428bd1]];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithHex:0x428bd1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHex:0xE1E1E1]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x428bd1]} forState:UIControlStateSelected];
    
    [UISearchBar appearance].tintColor = [UIColor colorWithHex:0x428bd1];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setCornerRadius:14.0];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAlpha:0.6];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xDCDCDC];
    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    
    [[UITextField appearance] setTintColor:[UIColor nameColor]];
    [[UITextView appearance]  setTintColor:[UIColor nameColor]];
    
}

@end
