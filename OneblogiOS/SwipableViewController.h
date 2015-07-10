//
//  SwipableViewController.h
//  OneblogiOS
//
//  Created by szgxa30 on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBarView.h"
#import "HorizonalTableViewController.h"

@interface SwipableViewController : UIViewController

@property (nonatomic, strong) HorizonalTableViewController *viewPager;
@property (nonatomic, strong) TitleBarView *titleBar;

- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers underTabbar:(BOOL)underTabbar;
- (instancetype)initWithTitle:(NSString *)title andSubTitles:(NSArray *)subTitles andControllers:(NSArray *)controllers;
- (void)scrollToViewAtIndex:(NSUInteger)index;

@end