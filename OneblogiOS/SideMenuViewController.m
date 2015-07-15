//
//  SideMenuViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/16.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "SideMenuViewController.h"
#import "Config.h"
#import "UIColor+Util.h"

@interface SideMenuViewController ()

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NSArray *usersInformation = [Config getUsersInformation];
//    UIImage *portrait = [Config getPortrait];
//    
//    UIView *headerView = [UIView new];
//    headerView.backgroundColor = [UIColor clearColor];
//    
//    UIImageView *portraitView = [UIImageView new];
//    portraitView.contentMode = UIViewContentModeScaleAspectFit;
//    //[portraitView setCornerRadius:30];
//    portraitView.userInteractionEnabled = YES;
//    portraitView.translatesAutoresizingMaskIntoConstraints = NO;
//    [headerView addSubview:portraitView];
//    
//    if (portrait == nil) {
//        portraitView.image = [UIImage imageNamed:@"default-portrait"];
//    } else {
//        portraitView.image = portrait;
//    }
//    
//    UILabel *nameLabel = [UILabel new];
//    nameLabel.text = usersInformation[0];
//    nameLabel.font = [UIFont boldSystemFontOfSize:20];
//    
////    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
////        nameLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
////    } else {
////        nameLabel.textColor = [UIColor colorWithHex:0x696969];
////    }
//    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [headerView addSubview:nameLabel];
//    
//    NSDictionary *views = NSDictionaryOfVariableBindings(portraitView, nameLabel);
//    NSDictionary *metrics = @{@"x": @([UIScreen mainScreen].bounds.size.width / 4 - 15)};
//    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[portraitView(60)]-10-[nameLabel]-15-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
//    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-x-[portraitView(60)]" options:0 metrics:metrics views:views]];
//    
//    portraitView.userInteractionEnabled = YES;
//    nameLabel.userInteractionEnabled = YES;
//    [portraitView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
//    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushLoginPage)]];
//    
//    return headerView;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *selectedBackground = [UIView new];
//    selectedBackground.backgroundColor = [UIColor colorWithHex:0xCFCFCF];
    [cell setSelectedBackgroundView:selectedBackground];
    
    cell.imageView.image = [UIImage imageNamed:@[@"sidemenu_blog", @"sidemenu_setting", @"sidemenu-night", @"sidemenu-software"][indexPath.row]];
    cell.textLabel.text = @[@"博客", @"设置", @"夜间模式", @"注销"][indexPath.row];
    
//    if (((AppDelegate *)[UIApplication sharedApplication].delegate).inNightMode){
        //cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//        if (indexPath.row == 2) {
//            cell.textLabel.text = @"日间模式";
//            cell.imageView.image = [UIImage imageNamed:@"sidemenu-day"];
//        }
//    } else {
        cell.textLabel.textColor=[UIColor colorWithHex:0x428bd1];
        if (indexPath.row == 2) {
            cell.textLabel.text = @"夜间模式";
            cell.imageView.image = [UIImage imageNamed:@"sidemenu-night"];
        }
//    }
    cell.textLabel.font = [UIFont systemFontOfSize:19];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

@end
