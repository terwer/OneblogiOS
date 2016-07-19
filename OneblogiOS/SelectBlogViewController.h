//
//  SelectBlogViewController.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/5.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnBlock) (NSString *footerUrlStr,NSString *footerApi);

@interface SelectBlogViewController : UIViewController

@property (nonatomic,copy)ReturnBlock returnBlock; // 回调的接口文字

@end
