//
//  UIImage+Util.h
//  iosapp
//
//  Created by Terwer Green on 2/13/15.
//  Copyright (c) 2015 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Util)

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;
- (UIImage *)cropToRect:(CGRect)rect;

@end
