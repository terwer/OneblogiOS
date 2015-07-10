//
//  Utils.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/9.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Util.h"
#import "UIColor+Util.h"
#import "UIImageView+Util.h"
#import "UIImage+Util.h"
#import "NSTextAttachment+Util.h"
#import "AFHTTPRequestOperationManager+Util.h"

@class MBProgressHUD;

@interface Utils : NSObject

+ (NSDictionary *)emojiDict;
+ (MBProgressHUD *)createHUD;
+ (NSString *)generateUserAgent;

@end
