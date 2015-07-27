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
    
    SwipableViewController *blogSVC = [[SwipableViewController alloc] initWithTitle:@"首页"
                                                                       andSubTitles:@[@"最新文章",@"热门文章",@"置顶文章"]
                                                                     andControllers:@[ postViewCtl,hotViewCtl,digViewCtl]
                                                                        underTabbar:YES];
    
    
    
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[
                             [self addNavigationItemForViewController:blogSVC]
                             ];
    
    
    NSArray *titles = @[@"文章"];
    NSArray *images = @[@"tabbar-news"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitle:titles[idx]];
        //NSLog(@"%@",images[idx]);
        //NSLog(@"%@",[images[idx] stringByAppendingString:@"-selected"]);
        if (!([images[idx] isEqualToString:@"blank"])) {
            [item setImage:[UIImage imageNamed:images[idx]]];
            [item setSelectedImage:[UIImage imageNamed:[images[idx] stringByAppendingString:@"-selected"]]];
        }
    }];
    
    
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

@end