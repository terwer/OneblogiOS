//
//  OBTabBarController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "OBTabBarController.h"
#import "OptionButton.h"
#import <RESideMenu/RESideMenu.h>
#import "PostViewController.h"
#import "SwipableViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MyInfoController.h"
#import "Utils.h"

@interface OBTabBarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, assign) BOOL isPressed;
@property (nonatomic, strong) NSMutableArray *optionButtons;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGGlyph length;

@end

@implementation OBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //全部
    PostViewController *postViewCtl = [PostViewController new];//[[BlogsViewController alloc] initWithBlogsType:BlogTypeLatest];
    //最新
    UIViewController *hotViewCtl = [UIViewController new];
    //热门
    UIViewController *digViewCtl = [UIViewController new];
    
    //博客
    SwipableViewController *blogSVC = [[SwipableViewController alloc] initWithTitle:@"首页"
                                                                       andSubTitles:@[@"最新文章",@"热门文章",@"置顶文章"]
                                                                     andControllers:@[ postViewCtl,hotViewCtl,digViewCtl]
                                                                        underTabbar:YES];
    
    
    //消息
    MessageViewController *messageCtl = [[MessageViewController alloc]initWithStyle:UITableViewStyleGrouped];
    //发现
    DiscoverViewController *discoverTableVC = [[DiscoverViewController alloc]initWithStyle:UITableViewStyleGrouped];
    //我
    MyInfoController *myInfoVC = [[MyInfoController alloc]init];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             [self addNavigationItemForViewController:blogSVC],
                             [self addNavigationItemForViewController:messageCtl],
                             [UIViewController new],
                             [self addNavigationItemForViewController:discoverTableVC],
                             [[UINavigationController alloc] initWithRootViewController:myInfoVC]
                             ];
    
    
    NSArray *titles = @[@"博客", @"消息", @"", @"发现", @"我"];
    NSArray *images = @[@"tabbar-news", @"tabbar-tweet", @"blank", @"tabbar-discover", @"tabbar-me"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        //NSLog(@"%@",images[idx]);
        //NSLog(@"%@",[images[idx] stringByAppendingString:@"-selected"]);
        if (!([images[idx] isEqualToString:@"blank"])) {
            [item setImage:[UIImage imageNamed:images[idx]]];
            [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
        }
    }];
    
    //禁用中间标签
    [self.tabBar.items[2] setEnabled:NO];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"tabbar-more"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UINavigationController *)addNavigationItemForViewController:(UIViewController *)viewController
{
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    viewController.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(onClickMenuButton)];
    
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"]
                                                                                        style:UIBarButtonItemStylePlain
                                                                                       target:self action:@selector(pushSearchViewController)];
    
    
    
    return navigationController;
}

-(void)onClickMenuButton{
}

-(void)pushSearchViewController{
}


-(void)addCenterButtonWithImage:(UIImage *)buttonImage
{
    _centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGPoint origin = [self.view convertPoint:self.tabBar.center toView:self.tabBar];
    CGSize buttonSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 6, self.tabBar.frame.size.height - 4);
    
    _centerButton.frame = CGRectMake(origin.x - buttonSize.height/2, origin.y - buttonSize.height/2, buttonSize.height, buttonSize.height);
    
    [_centerButton setCornerRadius:buttonSize.height/2];
    [_centerButton setBackgroundColor:[UIColor colorWithHex:0x428bd1]];
    [_centerButton setImage:buttonImage forState:UIControlStateNormal];
    [_centerButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:_centerButton];
}

-(void)buttonPressed{

}

@end