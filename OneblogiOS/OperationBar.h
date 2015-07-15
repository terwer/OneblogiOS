//
//  OperationBar.h
//  iosapp
//
//  Created by ChanAetern on 1/19/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationBar : UIToolbar

@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) UIButton *commentsButton;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *reportButton;

@property (nonatomic, assign) BOOL isStarred;

@property (nonatomic, copy) void (^switchMode)();
@property (nonatomic, copy) void (^showComments)();
@property (nonatomic, copy) void (^editComment)();
@property (nonatomic, copy) void (^toggleStar)();
@property (nonatomic, copy) void (^share)();
@property (nonatomic, copy) void (^report)();

@end
