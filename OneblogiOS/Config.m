//
//  Config.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Config.h"

@implementation Config

/**
 *  获取是否夜间模式
 *
 *  @return 是否夜间模式
 */
+ (BOOL)getMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

/**
 *  获取MetaWeblog API的授权信息
 *
 *  @return ApiInfo
 */
+(ApiInfo *)getAuthoizedApiInfo
{
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isJSONAPIEnable = [[userDefaults objectForKey:@"isJSONAPIEnable"] boolValue];
    NSString *baseURL = [userDefaults objectForKey:@"baseURL"];
    NSString *username = [userDefaults objectForKey:@"mw_username"];
    NSString *password = [userDefaults objectForKey:@"mw_password"];
    NSString *cookie = [userDefaults objectForKey:@"generate_auth_cookie"];
    //初始化ApiInfo
    ApiInfo *apiInfo = nil;
    if (isJSONAPIEnable) {
        apiInfo = [[ApiInfo alloc]initWithXmlrpc:baseURL andUsername:username andPassword:password];
    }else{
        apiInfo = [[ApiInfo alloc]initWithBaseURL:baseURL andGenerateAuthCookie:cookie];
    }
    //结果处理
    if (apiInfo) {return apiInfo;}
    return nil;
}

/**
 *  是否启用高级API（注意：如果启用了，需要服务端支持，https://github.com/terwer/SDFeedParser）
 *
 *  @return 高级API开启状态
 */
+(BOOL)isAnvancedAPIEnable{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    BOOL result = [[settings objectForKey:@"IsAdvancedAPIEnable"] boolValue];
    return result;
}

/**
 *  是否显示页面（默认只显示文章）
 *
 *  @return 是否显示页面
 */
+(BOOL)isShowPage{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    BOOL result = [[settings objectForKey:@"IsShowPage"] boolValue];
    return result;
}

/**
 *  是否针对Wordpress优化
 *
 *  @return 是否针对Wordpress优化
 */
+(BOOL)isWordpressOptimization{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    BOOL result = [[settings objectForKey:@"IsWordpressOptimization"] boolValue];
    return result;
}

@end
