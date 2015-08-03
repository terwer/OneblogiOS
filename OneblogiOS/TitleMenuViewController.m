//
//  TitleMenuTableViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/4.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "TitleMenuViewController.h"
#import "DropdownMenuView.h"

@interface TitleMenuViewController ()

@property (nonatomic, strong) NSMutableArray * data;

@end

@implementation TitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
    [_data addObject:@"全部分类"];
    [_data addObject:@"iOS"];
    [_data addObject:@"Objective-C"];
    [_data addObject:@"Swift"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    NSString * name = _data[indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}

#pragma mark Cell点击事件处理器
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dropdownMenuView) {
        [_dropdownMenuView dismiss];
    }
    
    if (_delegate) {
        [_delegate selectAtIndexPath:indexPath title:_data[indexPath.row]];
    }
    
}

@end