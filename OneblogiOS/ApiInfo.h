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
 *  xmlrpc链接
 */
@property NSString *xmlrpc;
/**
 *  用户名
 */
@property NSString *username;
/**
 *  密码
 */
@property NSString *password;

/**
 *  初始化
 *
 *  @param xmlrpc   xmlrpc链接
 *  @param username 用户名
 *  @param password 密码
 *
 *  @return ApiInfo实例
 */
-(instancetype)initWithXmlrpc:(NSString *)xmlrpc andUsername:(NSString *)username andPassword:(NSString *)password;
@end
