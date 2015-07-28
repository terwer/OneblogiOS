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

+(ApiInfo *)getAuthoizedApiInfo;
@end
