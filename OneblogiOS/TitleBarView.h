//
//  TitleBarView.h
//  OneblogiOS
//
//  Created by szgxa30 on 15/7/10.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleBarView : UIScrollView

@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, copy) void (^titleButtonClicked)(NSUInteger index);

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray*)titles;

@end
