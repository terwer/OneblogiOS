//
//  MyInfoViewController.m
//  OneblogiOS
//
//  Created by szgxa30 on 15/7/15.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "MyInfoViewController.h"
#import "Config.h"
#import "Utils.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyInfoViewController ()

//@property (nonatomic, strong) OBMyInfo *myInfo;
//@property (nonatomic, readonly, assign) int64_t myID;
//@property (nonatomic, strong) NSMutableArray *noticeCounts;
//
//@property (nonatomic, strong) UIImageView *portrait;
//@property (nonatomic, strong) UILabel *nameLabel;
//@property (nonatomic, strong) UIImageView *myQRCodeButton;
//
//@property (nonatomic, strong) UIButton *creditsBtn;
//@property (nonatomic, strong) UIButton *collectionsBtn;
//@property (nonatomic, strong) UIButton *followsBtn;
//@property (nonatomic, strong) UIButton *fansBtn;
//
//@property (nonatomic, assign) int badgeValue;

@end

@implementation MyInfoViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeUpdateHandler:) name:OSCAPI_USER_NOTICE object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefreshHandler:)  name:@"userRefresh"     object:nil];
//        
//        _noticeCounts = [NSMutableArray arrayWithArray:@[@(0), @(0), @(0), @(0), @(0)]];
    }
    
    return self;
}

- (void)dawnAndNightMode
{
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-search"] style:UIBarButtonItemStylePlain target:self action:@selector(pushSearchViewController)];
//    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.bounces = NO;
    self.navigationItem.title = @"我";
    //    self.view.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    self.tableView.backgroundColor = [UIColor themeColor];
    self.tableView.separatorColor = [UIColor separatorColor];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footer;
    
    [self refreshView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshView
{
}

//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray *usersInformation = [Config getUsersInformation];
//    
//    UIImageView *header = [UIImageView new];
//    header.userInteractionEnabled = YES;
//    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
//    NSString *imageName = @"user-background";
//    if (screenWidth.intValue < 400) {
//        imageName = [NSString stringWithFormat:@"%@-%@", imageName, screenWidth];;
//    }
//    header.image = [UIImage imageNamed:imageName];
//    
//    UIView *imageBackView = [UIView new];
//    imageBackView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
//    [imageBackView setCornerRadius:27];
//    [header addSubview:imageBackView];
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header.image.size.width, header.image.size.height)];
//    view.backgroundColor = [UIColor infosBackViewColor];
//    [header addSubview:view];
//    
//    _portrait = [UIImageView new];
//    _portrait.contentMode = UIViewContentModeScaleAspectFit;
//    [_portrait setCornerRadius:25];
//    if (_myID == 0) {
//        _portrait.image = [UIImage imageNamed:@"default-portrait"];
//    } else {
//        UIImage *portrait = [Config getPortrait];
//        if (portrait == nil) {
//            [_portrait sd_setImageWithURL:_myInfo.portraitURL
//                         placeholderImage:[UIImage imageNamed:@"default-portrait"]
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                    [Config savePortrait:image];
//                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRefresh" object:@(YES)];
//                                }];
//        } else {
//            _portrait.image = portrait;
//        }
//    }
//    _portrait.userInteractionEnabled = YES;
//    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)]];
//    [header addSubview:_portrait];
//    
//    UIImageView *genderImageView = [UIImageView new];
//    genderImageView.hidden = YES;
//    genderImageView.contentMode = UIViewContentModeScaleAspectFit;
//    if (_myID == 0) {
//        //
//    } else {
//        if (_myInfo.gender == 1) {
//            [genderImageView setImage:[UIImage imageNamed:@"userinfo_icon_male"]];
//            genderImageView.hidden = NO;
//        } else if (_myInfo.gender == 2){
//            [genderImageView setImage:[UIImage imageNamed:@"userinfo_icon_female"]];
//            genderImageView.hidden = NO;
//        }
//        
//    }
//    [header addSubview:genderImageView];
//    
//    _nameLabel = [UILabel new];
//    _nameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
//    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
//    _nameLabel.text = usersInformation[0];
//    [header addSubview:_nameLabel];
//    
//    UIButton *QRCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    QRCodeButton.titleLabel.font = [UIFont fontAwesomeFontOfSize:25];
////    [QRCodeButton setTitle:[NSString fontAwesomeIconStringForEnum:FAQrcode] forState:UIControlStateNormal];
////    [QRCodeButton addTarget:self action:@selector(showQRCode) forControlEvents:UIControlEventTouchUpInside];
//    [header addSubview:QRCodeButton];
//    
//    _creditsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _collectionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _followsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    UIView *line = [UIView new];
//    line.backgroundColor = [UIColor lineColor];
//    //    line.backgroundColor = [UIColor redColor];
//    [header addSubview:line];
//    
//    UIView *countView = [UIView new];
//    [header addSubview:countView];
//    
//    void (^setButtonStyle)(UIButton *, NSString *) = ^(UIButton *button, NSString *title) {
//        [button setTitleColor:[UIColor colorWithHex:0xEEEEEE] forState:UIControlStateNormal];
//        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        button.titleLabel.font = [UIFont systemFontOfSize:15];
//        [button setTitle:title forState:UIControlStateNormal];
//        [countView addSubview:button];
//    };
//    
//    setButtonStyle(_creditsBtn, [NSString stringWithFormat:@"积分\n%d", _myInfo.score]);
//    setButtonStyle(_collectionsBtn, [NSString stringWithFormat:@"收藏\n%d", _myInfo.favoriteCount]);
//    setButtonStyle(_followsBtn, [NSString stringWithFormat:@"关注\n%d", _myInfo.followersCount]);
//    setButtonStyle(_fansBtn, [NSString stringWithFormat:@"粉丝\n%d", _myInfo.fansCount]);
//    
//    
//    [_creditsBtn setTitle:[NSString stringWithFormat:@"积分\n%@", usersInformation[1]] forState:UIControlStateNormal];
//    [_collectionsBtn setTitle:[NSString stringWithFormat:@"收藏\n%@", usersInformation[2]] forState:UIControlStateNormal];
//    [_followsBtn setTitle:[NSString stringWithFormat:@"关注\n%@", usersInformation[3]] forState:UIControlStateNormal];
//    [_fansBtn setTitle:[NSString stringWithFormat:@"粉丝\n%@", usersInformation[4]] forState:UIControlStateNormal];
//    
//    
//    [_collectionsBtn addTarget:self action:@selector(pushFavoriteSVC) forControlEvents:UIControlEventTouchUpInside];
//    [_followsBtn addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];
//    [_fansBtn addTarget:self action:@selector(pushFriendsSVC:) forControlEvents:UIControlEventTouchUpInside];
//    
//    for (UIView *view in header.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
//    for (UIView *view in countView.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(imageBackView, _portrait, genderImageView, _nameLabel, _creditsBtn, _collectionsBtn, _followsBtn, _fansBtn, QRCodeButton, countView, line);
//    NSDictionary *metrics = @{@"width": @(tableView.frame.size.width / 4)};
//    
//    
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_portrait(50)]-8-[_nameLabel]-10-[line(1)]-4-[countView(50)]|"
//                                                                   options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[line]|" options:0 metrics:nil views:views]];
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_portrait(50)]" options:0 metrics:nil views:views]];
//    
//    ///背景白圈
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageBackView(54)]"
//                                                                   options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[imageBackView(54)]" options:0 metrics:nil views:views]];
//    [header addConstraint:[NSLayoutConstraint constraintWithItem:imageBackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
//                                                          toItem:_portrait attribute:NSLayoutAttributeCenterX multiplier:1 constant:27]];
//    [header addConstraint:[NSLayoutConstraint constraintWithItem:imageBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
//                                                          toItem:_portrait attribute:NSLayoutAttributeCenterY multiplier:1 constant:27]];
//    
//    ////男女区分图标
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[genderImageView(15)]"
//                                                                   options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[genderImageView(15)]" options:0 metrics:nil views:views]];
//    [header addConstraint:[NSLayoutConstraint constraintWithItem:_portrait attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
//                                                          toItem:genderImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:7.5]];
//    [header addConstraint:[NSLayoutConstraint constraintWithItem:_portrait attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
//                                                          toItem:genderImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:7.5]];
//    
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[countView]|" options:0 metrics:nil views:views]];
//    
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[QRCodeButton]" options:0 metrics:nil views:views]];
//    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[QRCodeButton]-15-|" options:0 metrics:nil views:views]];
//    
//    [countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_creditsBtn(width)][_collectionsBtn(width)][_followsBtn(width)][_fansBtn(width)]|"
//                                                                      options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:metrics views:views]];
//    [countView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_creditsBtn]|" options:0 metrics:nil views:views]];
//    
//    
////    if ([Config getOwnID] == 0) {
////        line.hidden = YES;
////        countView.hidden = YES;
////        QRCodeButton.hidden = YES;
////    }
//    
//    return header;
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    
    UIView *selectedBackground = [UIView new];
    selectedBackground.backgroundColor = [UIColor colorWithHex:0xF5FFFA];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.backgroundColor = [UIColor cellsColor];//colorWithHex:0xF9F9F9
    
    cell.textLabel.text = @[@"消息", @"博客", @"团队"][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@[@"me-message", @"me-blog", @"me-team"][indexPath.row]];
    
    cell.textLabel.textColor = [UIColor titleColor];
    
//    if (indexPath.row == 0) {
//        if (_badgeValue == 0) {
//            cell.accessoryView = nil;
//        } else {
//            UILabel *accessoryBadge = [UILabel new];
//            accessoryBadge.backgroundColor = [UIColor redColor];
//            accessoryBadge.text = [@(_badgeValue) stringValue];
//            accessoryBadge.textColor = [UIColor whiteColor];
//            accessoryBadge.textAlignment = NSTextAlignmentCenter;
//            accessoryBadge.layer.cornerRadius = 11;
//            accessoryBadge.clipsToBounds = YES;
//            
//            CGFloat width = [accessoryBadge sizeThatFits:CGSizeMake(MAXFLOAT, 26)].width + 8;
//            width = width > 26? width: 22;
//            accessoryBadge.frame = CGRectMake(0, 0, width, 22);
//            cell.accessoryView = accessoryBadge;
//        }
//    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //return 160;
    return 23;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


@end
