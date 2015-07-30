//
//  DetailsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "BottomBarViewController.h"

@interface DetailsViewController : BottomBarViewController

/**
 *  详情实体
 */
@property NSDictionary *result;

/**
 *  用post初始化详情页面
 *
 *  @param post 文章
 *
 *  @return 详情页面
 */
- (instancetype)initWithPost:(NSDictionary *)post;

@end
