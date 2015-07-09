//
//  AFHTTPRequestOperationManager+Util.m
//  iosapp
//
//  Created by AeternChan on 6/18/15.
//  Copyright (c) 2015 oschina. All rights reserved.
//

#import "AFHTTPRequestOperationManager+Util.h"

#import <AFOnoResponseSerializer.h>

@implementation AFHTTPRequestOperationManager (Util)

+ (instancetype)OSCManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [manager.requestSerializer setValue:[self generateUserAgent] forHTTPHeaderField:@"User-Agent"];
    
    return manager;
}

+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"OSChina.NET/%@/%@/%@/%@/%@", appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}

@end
