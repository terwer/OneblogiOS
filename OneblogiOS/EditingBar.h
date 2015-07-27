//
//  EditingBar.h
//  iosapp
//
//  Created by Terwer Green on 11/4/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"

@interface EditingBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) GrowingTextView *editView;
@property (nonatomic, strong) UIButton *modeSwitchButton;
@property (nonatomic, strong) UIButton *inputViewButton;

- (instancetype)initWithModeSwitchButton:(BOOL)hasAModeSwitchButton;

@end
