//
//  ApiInfo.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/29.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiInfo : NSObject

/**
 *  baseURL（MetaWeblogApi时为xmlrpcURL，JSON API时为八色URL）
 */
@property (nonatomic,strong) NSString *baseURL;
/**
 *  用户名
 */
@property (nonatomic,strong) NSString *username;
/**
 *  密码
 */
@property (nonatomic,strong) NSString *password;
/**
 *  JSON API才会用到
 */
@property (nonatomic,strong) NSString * generateAauthCookie;

/**
 *  初始化metaWeblog API
 *
 *  @param xmlrpc   xmlrpc链接
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return ApiInfo实例
 */
-(instancetype)initWithXmlrpc:(NSString *)xmlrpc andUsername:(NSString *)username andPassword:(NSString *)password;

/**
 *  初始化JSON API
 *
 *  @param baseURL  baseURL
 *  @param username username
 *  @param password password
 *
 *  @return ApiInfo实例
 */
-(instancetype)initWithBaseURL:(NSString *)baseURL andUsername:(NSString *)username andPassword:(NSString *)password;
@end
