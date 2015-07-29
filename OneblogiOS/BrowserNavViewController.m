//
//  BrowserNavViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/29.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "BrowserNavViewController.h"
#import "BrowserViewController.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "Utils.h"

@interface BrowserNavViewController ()<UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) MBProgressHUD *HUD;


@end

@implementation BrowserNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _detailsView = [UIWebView new];
    _detailsView.delegate = self;
    _detailsView.scrollView.delegate = self;
    _detailsView.scrollView.bounces = NO;
    _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_detailsView];
    
    // 添加等待动画
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    
    _manager = [AFHTTPRequestOperationManager manager];
    //_manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self fetchDetails];
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

/**
 *  访问网页
 */
- (void)fetchDetails
{
    NSLog(@"fetch details");
    
//    [_manager POST:@"http://www.baidu.com/"
//        parameters:nil
//           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Result: %@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error:%@",error);
//    }];
//    
//    return;
//    
//        [_manager GET:[_url absoluteString]
//           parameters:nil
//              success:^(AFHTTPRequestOperation *operation,id responseDocument) {
//                  NSLog(@"%@",responseDocument);
//    //
//    //              id details = [[_detailsClass alloc] initWithXML:XML];
//    //              _commentCount = [[[XML firstChildWithTag:@"commentCount"] numberValue] intValue];
//    //              [self performSelector:_loadMethod withObject:details];
//    //
//    //              self.operationBar.isStarred = _isStarred;
//    //
//    //              UIBarButtonItem *commentsCountButton = self.operationBar.items[4];
//    //              commentsCountButton.shouldHideBadgeAtZero = YES;
//    //              commentsCountButton.badgeValue = [NSString stringWithFormat:@"%i", _commentCount];
//    //              commentsCountButton.badgePadding = 1;
//    //              commentsCountButton.badgeBGColor = [UIColor colorWithHex:0x24a83d];
//    //
//    //              if (_commentType == CommentTypeSoftware) {_objectID = ((OSCSoftwareDetails *)details).softwareID;}
//    //
//    //              [self setBlockForOperationBar];
//              }
//              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                  _HUD.mode = MBProgressHUDModeCustomView;
//                  _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
//                  NSString *errorMesage =  [NSString stringWithFormat:@"网络异常，加载详情失败:%@",[error localizedDescription]];
//                  _HUD.labelText = errorMesage;
//                  NSLog(@"%@",errorMesage);
//                  [_HUD hide:YES afterDelay:1];
//              }
//         ];
}

/**
 *  刷新
 */
- (void)refresh
{
    _manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    [self fetchDetails];
}



@end
