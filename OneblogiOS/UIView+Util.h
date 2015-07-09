//
//  UIView+Util.h
//  iosapp
//
//  Created by Terwer Green on 14-10-17.
//  Copyright (c) 2014年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWidth:(CGFloat)width andColor:(UIColor *)color;

- (UIImage *)convertViewToImage;
- (UIImage *)updateBlur;

@end
