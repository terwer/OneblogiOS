//
//  LastCell.m
//  iosapp
//
//  Created by Terwer Green on 14-10-18.
//  Copyright (c) 2014年 Terwer Green. All rights reserved.
//

#import "LastCell.h"
#import "UIColor+Util.h"

@interface LastCell ()

//@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation LastCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor themeColor];
        
        _status = LastCellStatusNotVisible;
        
        [self setLayout];
    }
    
    return self;
}

- (void)setLayout
{
    _textLabel.textColor = [UIColor titleColor];
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _textLabel.backgroundColor = [UIColor themeColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_textLabel];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _indicator.color = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1.0];
    _indicator.center = self.center;
    [self addSubview:_indicator];
}


- (BOOL)shouldResponseToTouch
{
    return _status == LastCellStatusMore || _status == LastCellStatusError;
}

- (void)setStatus:(LastCellStatus)status
{
    if (status == LastCellStatusLoading) {
        [_indicator startAnimating];
        _indicator.hidden = NO;
    } else {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    
    _textLabel.text = @[
                        @"",
                        @"点击加载更多",
                        @"",
                        @"加载数据出错",
                        @"全部加载完毕",
                        _emptyMessage ?: @"",
                        ][status];
    
    _status = status;
}


@end
