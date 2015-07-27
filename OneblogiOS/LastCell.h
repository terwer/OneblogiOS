//
//  LastCell.h
//  iosapp
//
//  Created by Terwer Green on 14-10-18.
//  Copyright (c) 2014年 Terwer Green. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LastCellStatus)
{
    LastCellStatusNotVisible,
    LastCellStatusMore,
    LastCellStatusLoading,
    LastCellStatusError,
    LastCellStatusFinished,
    LastCellStatusEmpty,
};

@interface LastCell : UITableViewCell

@property (nonatomic, assign) LastCellStatus status;
@property (readonly, nonatomic, assign) BOOL shouldResponseToTouch;
@property (nonatomic, copy) NSString *emptyMessage;


@end
