//
//  Utils.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (NSString *)generateUserAgent
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *IDFV = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return [NSString stringWithFormat:@"terwer.com/%@/%@/%@/%@/%@", appVersion,
            [UIDevice currentDevice].systemName,
            [UIDevice currentDevice].systemVersion,
            [UIDevice currentDevice].model,
            IDFV];
}


@end
