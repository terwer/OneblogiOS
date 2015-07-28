//
//  DetailsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "DetailsViewController.h"
#import "Utils.h"
#import <MBProgressHUD.h>

@interface DetailsViewController () <UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property NSDictionary * result;
@property (nonatomic, strong) UILabel *labelDescription;

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
        //_loadMethod = @selector(loadBlogDetails:);
        NSLog(@"init post details...");
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refresh)];
    
    //  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailsView]|" options:0 metrics:nil views:nil]];
    //  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailsView][bottomBar]"
    //                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
    //                                                                      metrics:nil views:views]];
    
    [self.view bringSubviewToFront:(UIView *)self.editingBar];
    
    [self.editingBar.modeSwitchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    // 添加等待动画
    //_HUD = [Utils createHUD];
    //_HUD.userInteractionEnabled = NO;
    
    self.labelDescription = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width,0)];
    
    [self fetchDetails];
    
    self.labelDescription.numberOfLines = 0;
    [self.labelDescription sizeToFit];
    [self.view addSubview:self.labelDescription];

    //((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
}


- (void)refresh
{
    [self fetchDetails];
}


- (void)fetchDetails
{
    //获取详情数据
    NSString *description = [self.result valueForKey:@"description"];
    //还原HTMl特殊字符
    NSString *originalHTML= [Utils unescapeHTML:description];
    //将Markdown转换为原生字符并显示
    NSAttributedString *attributedString = [Utils attributedMarkdown:originalHTML];
    [self.labelDescription setAttributedText: attributedString];
    NSAssert(@"override by subview",false);
}
@end
