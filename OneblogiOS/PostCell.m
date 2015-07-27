




//
//  PostCell.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "PostCell.h"
#import "Utils.h"

@implementation PostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor themeColor];
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}


- (void)initSubviews
{
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:self.titleLabel];
    
    self.bodyLabel = [UILabel new];
    self.bodyLabel.numberOfLines = 0;
    self.bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bodyLabel.font = [UIFont systemFontOfSize:13];
    self.bodyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.bodyLabel];
    
    self.authorLabel = [UILabel new];
    self.authorLabel.font = [UIFont systemFontOfSize:12];
    self.authorLabel.textColor = [UIColor nameColor];
    [self.contentView addSubview:self.authorLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.commentCount = [UILabel new];
    self.commentCount.font = [UIFont systemFontOfSize:12];
    self.commentCount.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.commentCount];
}

- (void)setLayout
{
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_titleLabel, _bodyLabel, _authorLabel, _timeLabel, _commentCount);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_titleLabel]-5-[_bodyLabel]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bodyLabel]-5-[_authorLabel]-8-|"
                                                                             options:NSLayoutFormatAlignAllLeft
                                                                             metrics:nil
                                                                               views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_titleLabel]-8-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDict]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_authorLabel]-10-[_timeLabel]-10-[_commentCount]"
                                                                             options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                             metrics:nil
                                                                               views:viewsDict]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
