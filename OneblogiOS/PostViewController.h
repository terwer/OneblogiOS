//
//  BlogsViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBObjsViewController.h"

/**
 *  文章类型枚举
 */
typedef NS_ENUM(NSUInteger, PostType){
    /**
     *  文章
     */
    PostTypePost,
    /**
     *  页面
     */
    PostTypePage,
};


/**
 *  API 类型枚举 15-08-04 by terwer
 */
typedef NS_ENUM(NSInteger,APIType){
    /**
     *  JSON API
     */
    APITypeJSON,
    /**
     *  Metaweblog API
     */
    APITypeMetaWeblog,
    /**
     *  Http API
     */
    APITypeHttp
};


/**
 *  文章结果类型枚举
 */
typedef NS_ENUM(NSUInteger, PostResultType){
    /**
     *  最近文章
     */
    PostResultTypeRecent,
    /**
     *  搜索文章
     */
    PostResultTypeSearch,
    /**
     *  分类文章
     */
    PostResultTypeCategory,
    /**
     *  标签文章
     */
    PostResultTypeTag
};

@interface PostViewController : OBObjsViewController

/**
 *  API类型
 */
@property (nonatomic) APIType apiType;
/**
 *  文章类型
 */
@property (nonatomic) PostType postType;
/**
 *  文章结果类型
 */
@property (nonatomic) PostResultType postResultType;
/**
 *  文章列表数据
 */
@property (nonatomic) NSArray *posts;
/**
 *  是否搜索
 */
@property (nonatomic)  BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic)  UISearchBar *searchBar;
/**
 *  文章搜索控制器
 */
@property   UISearchController *postSearchController;
/**
 *  下拉分类
 */
@property (nonatomic, strong) UIButton *titleButton;
/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostType)type;

@end
