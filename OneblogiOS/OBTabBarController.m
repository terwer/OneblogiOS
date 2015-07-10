//
//  OBTabBarController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "OBTabBarController.h"
#import "SwipableViewController.h"
//#import "TweetsViewController.h"
//#import "PostsViewController.h"
//#import "NewsViewController.h"
#import "BlogsViewController.h"
//#import "LoginViewController.h"
//#import "DiscoverTableVC.h"
//#import "MyInfoViewController.h"
//#import "Config.h"
//#import "Utils.h"
//#import "OptionButton.h"
//#import "TweetEditingVC.h"
//#import "UIView+Util.h"
//#import "PersonSearchViewController.h"
//#import "ScanViewController.h"
//#import "ShakingViewController.h"
//#import "SearchViewController.h"
//#import "VoiceTweetEditingVC.h"

//#import "UIBarButtonItem+Badge.h"

#import <RESideMenu/RESideMenu.h>

@interface OBTabBarController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (nonatomic, strong) UIView *dimView;
//@property (nonatomic, strong) UIImageView *blurView;
//@property (nonatomic, assign) BOOL isPressed;
//@property (nonatomic, strong) NSMutableArray *optionButtons;
//@property (nonatomic, strong) UIDynamicAnimator *animator;
//
//@property (nonatomic, assign) CGFloat screenHeight;
//@property (nonatomic, assign) CGFloat screenWidth;
//@property (nonatomic, assign) CGGlyph length;

@end

@implementation OBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BlogsViewController *blogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogTypeLatest];
    //BlogsViewController *recommendBlogViewCtl = [[BlogsViewController alloc] initWithBlogsType:BlogTypeRecommended];

    //blogViewCtl.needCache = YES;
    
    SwipableViewController *newsSVC = [[SwipableViewController alloc] initWithTitle:@"综合"
                                                                       andSubTitles:@[ @"博客"]
                                                                     andControllers:@[ blogViewCtl]
                                                                        underTabbar:YES];
  
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             [self addNavigationItemForViewController:newsSVC]
                             ];
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


#pragma mark -

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

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - 处理左右navigationItem点击事件

- (void)pushSearchViewController
{
    //[(UINavigationController *)self.selectedViewController pushViewController:[SearchViewController new] animated:YES];
}


@end
