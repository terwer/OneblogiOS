//
//  Utils.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Util.h"
#import "UIView+Util.h"
#import "UIImage+Util.h"
#import "UIFont+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import <MBProgressHUD.h>

static NSString * const kKeyYears = @"years";
static NSString * const kKeyMonths = @"months";
static NSString * const kKeyDays = @"days";
static NSString * const kKeyHours = @"hours";
static NSString * const kKeyMinutes = @"minutes";

@interface Utils : NSObject

/**
 *  去除字符串里面的空格、换行以及Markdown特殊字符，如：＝、＃ 15-07-27 by terwer
 *
 *  @param str 原字符串
 *
 *  @return 处理后的字符串
 */
+(NSString *)removeSpaceAndNewlineAndChars:(NSString *)str;

/**
 *  美化评论显示 15-07-27 by terwer
 *
 *  @param commentCount 评论数目
 *
 *  @return 处理后的字符串
 */
+ (NSAttributedString *)attributedCommentCount:(int)commentCount;

/**
 *  显示时间距离现在的信息 15-07-27 by terwer
 *
 *  @param dateStr 原始时间字符串
 *
 *  @return 处理后的信息
 */;
+ (NSAttributedString *)attributedTimeString:(NSDate *)date;

/**
 *  创建提示框 15-0727 by terwer
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)createHUD;
@end
