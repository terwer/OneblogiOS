//
//  CategoryCell.h
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/4.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
/**
 *  分类名
 */
@property (nonatomic,strong) NSString *title;
/**
 *  分类别名
 */
@property (nonatomic,strong) NSString *slug;
/**
 *  分类ID
 */
@property (nonatomic) NSInteger catId;

@end
