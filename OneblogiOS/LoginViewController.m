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

@interface LoginViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>

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

@property(nonatomic, strong) TTTAttributedLabel *registerInfo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"登录";
    //self.view.backgroundColor = [UIColor themeColor];

    [self initSubviews];
    [self setLayout];

    //NSArray *accountAndPassword = [Config getOwnAccountAndPassword];
    //_accountField.text = accountAndPassword? accountAndPassword[0] : @"";
    //_passwordField.text = accountAndPassword? accountAndPassword[1] : @"";

    //RACSignal *valid = [RACSignal combineLatest:@[_accountField.rac_textSignal, _passwordField.rac_textSignal]
    //                                     reduce:^(NSString *account, NSString *password) {
    //                                         return @(account.length > 0 && password.length > 0);
    //                                     }];
    //RAC(_loginButton, enabled) = valid;
    //RAC(_loginButton, alpha) = [valid map:^(NSNumber *b) {
    //    return b.boolValue ? @1: @0.4;
    //}];
//
//    
//    //主界面视图
//    OBTabBarController *tabBarController = [OBTabBarController new];
//    
//    //初始化布局，这是整个视图的入口
//    RESideMenu *sideMenuTabBarViewController = [[RESideMenu alloc] initWithContentViewController:tabBarController leftMenuViewController: [SideMenuViewController new] rightMenuViewController:nil];
//    [self.navigationController pushViewController:sideMenuTabBarViewController
//                       animated:NO];
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

- (void)returnOnKeyboard:(id)sender {

}

- (void)login {

}

- (void)hidenKeyboard {

}
@end
