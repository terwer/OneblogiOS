//
//  Config.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiInfo.h"

@interface Config : NSObject

/**
 *  获取是否夜间模式
 *
 *  @return 是否夜间模式
 */
+ (BOOL)getMode;

/**
 *  获取MetaWeblog API的授权信息
 *
 *  @return ApiInfo
 */
+(ApiInfo *)getAuthoizedApiInfo;

/**
 *  是否启用高级API（注意：如果启用了，需要服务端支持，https://github.com/terwer/SDFeedParser）
 *
 *  @return 高级API开启状态
 */
+(BOOL)isAnvancedAPIEnable;

/**
 *  是否显示页面（默认只显示文章）
 *
 *  @return 是否显示页面
 */
+(BOOL)isShowPage;

/**
 *  是否针对Wordpress优化
 *
 *  @return 是否针对Wordpress优化
 */
+(BOOL)isWordpressOptimization;
@end
