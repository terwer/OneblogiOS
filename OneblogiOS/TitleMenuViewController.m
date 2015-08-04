//
//  TitleMenuTableViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/4.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "TitleMenuViewController.h"
#import "DropdownMenuView.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>
#import "CategoryCell.h"

static NSString *kCategoryCellID = @"categoryCell";

@interface TitleMenuViewController ()

@property (nonatomic, strong) NSMutableArray * data;

@end

@implementation TitleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册cell
    [self.tableView registerClass:[CategoryCell class] forCellReuseIdentifier:kCategoryCellID];
    
    [self fetchCategories];
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
    
    NSString * name = [_data[indexPath.row] objectForKey:@"title"];
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
        [_delegate selectAtIndexPathAndID:indexPath ID:[[_data[indexPath.row] objectForKey:@"id"]  integerValue] title:[_data[indexPath.row] objectForKey:@"title"]];
    }
    
}



# pragma mark 加载分类
/**
 *  加载分类，仅仅JSON API才支持
 */
-(void)fetchCategories{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_category_index/",JSONApiBaseURL];
    
    //创建加载中
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.detailsLabelText = @"分类加载中...";
    
    NSLog(@"category request URL:%@",requestURL);
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新数据
            //NSLog(@"JSON: %@", responseObject);
            NSLog(@"status:%@",[result objectForKey:@"status"]);
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"ok"]) {
                //获取数据
                NSLog(@"categories get ok :%lu",(unsigned long)result.count);
                
                self.data = [result objectForKey:@"categories"];
                //刷新数据
                [self.tableView reloadData];
                
                //取消加载中
                [HUD hide:YES afterDelay:1];
            }else{
                NSLog(@"category posts get error");
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching authors: %@", [error localizedDescription]);
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
        
        [self.tableView reloadData];
    }];
}


@end