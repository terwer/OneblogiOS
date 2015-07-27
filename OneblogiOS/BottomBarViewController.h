//
//  BottomBarViewController.h
//  iosapp
//
//  Created by Terwer Green on 11/19/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingBar.h"
#import "OperationBar.h"

@class EmojiPageVC;

@interface BottomBarViewController : UIViewController

@property (nonatomic, strong) EditingBar *editingBar;
@property (nonatomic, strong) OperationBar *operationBar;
@property (nonatomic, strong) NSLayoutConstraint *editingBarYConstraint;
@property (nonatomic, strong) NSLayoutConstraint *editingBarHeightConstraint;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;
- (void)sendContent;
- (void)updateInputBarHeight;
- (void)hideEmojiPageView;

@end
