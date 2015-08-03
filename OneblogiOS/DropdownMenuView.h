//
//  DropdownMenuView.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/4.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenuView;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenuView *)menu;
- (void)dropdownMenuDidShow:(DropdownMenuView *)menu;
@end

@interface DropdownMenuView : UIView

@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;

#pragma mark 在指定UIView下方显示菜单
- (void)showFrom:(UIView *)from;

#pragma mark 销毁下拉菜单
- (void)dismiss;

// 要显示的内容控制器
@property (nonatomic, strong) UIViewController *contentController;

@end
