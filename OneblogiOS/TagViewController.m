//
//  MessageViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "TagViewController.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>

@interface TagViewController ()
@property (strong, nonatomic) WWTagsCloudView* tagCloud;
@property (strong, nonatomic) NSMutableArray* tags;
@property (strong, nonatomic) NSArray *sortedTags;
@end

@implementation TagViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取并生成标签
    [self fetchTags];
    
    UIViewController *ctl =  [self.navigationController.viewControllers objectAtIndex:0];
    [ctl setTitle:@"标签"];
    ctl.navigationItem.rightBarButtonItem = nil;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  标签点击事件
 *
 *  @param tagIndex 点击的索引
 */
-(void)tagClickAtIndex:(NSInteger)tagIndex
{
    NSInteger tagID = [self getIDByTag:_tags[tagIndex]];
    NSLog(@"%d",tagID);
}

/**
 *  根据标签内容获取标签ID
 *
 *  @param tag 标签文本
 *
 *  @return 标签ID
 */
-(NSInteger)getIDByTag:(NSString *)tag{
    NSInteger result;
    for (id tempTag in _sortedTags) {
        if ([[tempTag objectForKey:@"title"] isEqualToString:tag]) {
            result = [[tempTag objectForKey:@"id"]integerValue];
            return result;
        }
    }
    
    return  0;
}

- (void)refresh:(id)sender {
    [_tagCloud reloadAllTags];
}

#pragma 生成标签
/**
 *  生成标签
 */
-(void)drawTags{
    NSArray* colors = @[[UIColor colorWithRed:0 green:0.63 blue:0.8 alpha:1], [UIColor colorWithRed:1 green:0.2 blue:0.31 alpha:1], [UIColor colorWithRed:0.53 green:0.78 blue:0 alpha:1], [UIColor colorWithRed:1 green:0.55 blue:0 alpha:1]];
    NSArray* fonts = @[[UIFont systemFontOfSize:12], [UIFont systemFontOfSize:16], [UIFont systemFontOfSize:20]];
    //初始化
    _tagCloud = [[WWTagsCloudView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)
                                               andTags:_tags                                          andTagColors:colors
                                              andFonts:fonts
                                       andParallaxRate:1.7
                                          andNumOfLine:10];
    _tagCloud.delegate = self;
    [self.view addSubview:_tagCloud];
}

# pragma mark 加载标签
/**
 *  加载标签，仅仅JSON API才支持
 */
-(void)fetchTags{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_tag_index/",JSONApiBaseURL];
    
    //创建加载中
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.detailsLabelText = @"标签加载中...";
    
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
                NSArray *detailedTags = result[@"tags"];
                //按标签文章倒叙排序
                _sortedTags = [detailedTags sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
                    NSInteger count1 = [[obj1 valueForKey:@"post_count"] integerValue];
                    NSInteger count2 = [[obj2 valueForKey:@"post_count"] integerValue];
                    if (count1 < count2)
                        return NSOrderedDescending;
                    else if (count1 > count2)
                        return NSOrderedAscending;
                    else
                        return NSOrderedSame;
                }];
                
                NSLog(@"tags get ok :%lu",(unsigned long)_sortedTags.count);
                _tags = [NSMutableArray array];
                for (id tempTag in _sortedTags) {
                    NSLog(@"%@",[tempTag valueForKey:@"title"]);
                    [_tags addObject:[tempTag valueForKey:@"title"]];
                }
                
                //生成标签
                [self drawTags];
                
                //取消加载中
                [HUD hide:YES afterDelay:1];
            }else{
                NSLog(@"tags get error");
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching authors: %@", [error localizedDescription]);
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
    }];
}



@end
