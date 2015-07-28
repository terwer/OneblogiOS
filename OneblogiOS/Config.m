//
//  Config.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/28.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Config.h"

@implementation Config

+ (BOOL)getMode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    return [[userDefaults objectForKey:@"mode"] boolValue];
}

+(ApiInfo *)getAuthoizedApiInfo
{
    //获取相关存储信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *xmlrpc = [userDefaults objectForKey:@"mw_xmlrpc"];
    NSString *username = [userDefaults objectForKey:@"mw_username"];
    NSString *password = [userDefaults objectForKey:@"mw_password"];
    //初始化ApiInfo
    ApiInfo *apiInfo = [[ApiInfo alloc]initWithXmlrpc:xmlrpc andUsername:username andPassword:password];
    //结果处理
    if (apiInfo) {return apiInfo;}
    return nil;
}
@end
