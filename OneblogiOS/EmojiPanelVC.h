//
//  EmojiPanelVC.h
//  iosapp
//
//  Created by Terwer Green on 12/21/14.
//  Copyright (c) 2014 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiPanelVC : UIViewController

- (instancetype)initWithPageIndex:(int)pageIndex;

@property (nonatomic, readonly, assign) int pageIndex;
@property (nonatomic, copy) void (^didSelectEmoji)(NSTextAttachment *textAttachment);
@property (nonatomic, copy) void (^deleteEmoji)();

@end
