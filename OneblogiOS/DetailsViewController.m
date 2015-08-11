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
#import "Config.h"
#import "TGBlogJsonApi.h"

#define HTML_STYLE @"<style>\
#oneblog_title {color: #000000; margin-bottom: 6px; font-weight:bold;}\
#oneblog_title a {color:#0D6DA8;}\
#oneblog_title img {vertical-align:middle; margin-right:6px;}\
#oneblog_outline {color: #707070; font-size: 12px;}\
#oneblog_outline a {color:#0D6DA8; text-decoration:none;}\
#oneblog_body {font-size:16px; line-height:24px;overflow:hidden}\
#oneblog_body img {max-width: 100%;}\
#oneblog_body table {max-width:100%;}\
#oneblog_body pre {font-size:9pt; font-family:Courier New, Arial; border:1px solid #ddd; border-left:5px solid #6CE26C; background:#f6f6f6; padding:5px;}\
</style>"

#define HTML_BOTTOM @"<div style='margin-bottom:60px'/>"

@interface DetailsViewController () <UIWebViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIWebView *detailsView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end

@implementation DetailsViewController

- (instancetype)initWithPost:(id)post
{
    self = [super initWithModeSwitchButton:YES];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
         self.result = post;
    }
    
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    
    NSDictionary *views = @{@"detailsView": _detailsView, @"bottomBar": self.editingBar};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detailsView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[detailsView][bottomBar]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
    // 添加等待动画
    _HUD = [Utils createHUD];
    _HUD.userInteractionEnabled = NO;
    
    [self fetchDetails:NO];
    
    //((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode = [Config getMode];
}

/**
 *  隐藏右侧和底部滚动条，去掉滚动边界的黑色背景,禁止左右滑动
 *
 *  @param webView webView
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //取消右侧，下侧滚动条，去处上下滚动边界的黑色背景
    for (UIView *_aView in [webView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            
            //下侧的滚动条
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                    
                }
                
            }
            
        }
        
    }
}


/**
 *  刷新
 */
- (void)refresh{
    NSLog(@"refreshing...");
    [self fetchDetails:YES];
}


/**
 *  访问网页
 */
- (void)fetchDetails:(BOOL)flag
{
    NSDictionary *post = _result;
    TGPost *jsonPost = _result;
    
    //博客相关变量
    NSString *title;//文章标题
    NSString *content;//文章内容
    NSDate *dateCreated;//发表时间
    NSString *author;//文章作者
    NSArray *categroies;//文章分类
    NSString *url;//文章链接
    //JSON API
    if ([Config isJSONAPIEnable]) {
        title = jsonPost.title;
        content = jsonPost.content;
        dateCreated = [Utils dateFromString:jsonPost.date];
        author = @"admin";
        categroies = jsonPost.categoriesArray;
        url = jsonPost.URL;
    }else{//MetaWeblogApi
        title = [post objectForKey:@"title"];
        content = [post objectForKey:@"description"];
        dateCreated = [post objectForKey:@"dateCreated"];
        author = [post objectForKey:@"wp_author_display_name"];
        categroies = [post objectForKey:@"categories"];
    }
    
    NSLog(@"post url:%@",url);
    NSString *authorStr = [NSString stringWithFormat:@"<a href='%@'>%@</a> 发布于 %@", url,author, [Utils intervalSinceNow:dateCreated]];
    
    NSString *postContent = [NSString stringWithFormat:@"<body style='background-color:#EBEBF3'>%@<div id='oneblog_title'>%@</div><div id='oneblog_outline'>%@</div><hr/><div id='oneblog_body'>%@</div>%@</body>", HTML_STYLE, title, authorStr, [Utils markdownToHtml:content], HTML_BOTTOM];
    
    NSLog(@"loading details");
    if (!flag) {
        NSString *htmlString = postContent;
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
            NSString *htmlString = [Utils markdownToHtml:responseHtml];
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
