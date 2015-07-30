//
//  DetailsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "DetailsViewController.h"
#import "Utils.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface DetailsViewController () <UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property NSDictionary * result;
@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation DetailsViewController

- (instancetype)initWithPost:(NSDictionary *)post
{
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"文章详情";
        self.result = post;
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    
    //添加WebView
    _detailsView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height)];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.scrollView.bounces = NO;
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //下面两行代码可以设置UIWebView的背景
    [_detailsView setBackgroundColor:[UIColor themeColor]];
    [_detailsView setOpaque:NO];
    
    [self.view addSubview:_detailsView];
    
    //编辑工具栏
    [self.view bringSubviewToFront:(UIView *)self.editingBar];
    [self.editingBar.modeSwitchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 添加等待动画
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    
    [self fetchDetails:NO];
    
    //((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
}

- (void)refresh{
    NSLog(@"refreshing...");
    [self fetchDetails:YES];
}


/**
 *  访问网页
 */
- (void)fetchDetails:(BOOL)flag
{
    NSLog(@"loading details");
    if (!flag) {
        NSString *htmlString = [Utils toMarkdownString: [ _result objectForKey:@"description"]];
        [_detailsView loadHTMLString:htmlString baseURL:nil];
        [_HUD hide:YES afterDelay:1];
    }else{
        
        NSLog(@"fetch details");
        NSString *str=[NSString stringWithFormat:@"%@",[_result objectForKey:@"link"]];
        NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *responseHtml = operation.responseString;
            NSString *htmlString = [Utils toMarkdownString:responseHtml];
            [_detailsView loadHTMLString:htmlString baseURL:nil];
            //NSLog(@"获取到的数据为：%@",html);
            //隐藏加载状态
            [_HUD hide:YES afterDelay:1];
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            _HUD.mode = MBProgressHUDModeCustomView;
            _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
            NSString *errorMesage =  [NSString stringWithFormat:@"网络异常，加载详情失败:%@",[error localizedDescription]];
            _HUD.labelText = errorMesage;
            NSLog(@"%@",errorMesage);
            [_HUD hide:YES afterDelay:1];
        }];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperation:operation];
    }
}

@end
