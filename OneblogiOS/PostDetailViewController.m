//
//  PostDetailViewController.m
//  OneblogiOS
//
//  Created by szgxa30 on 15/7/30.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "PostDetailViewController.h"
#import "PostEditViewController.h"

@interface PostDetailViewController ()

@end

@implementation PostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"This is post detail...");
    
    self.navigationItem.title = @"文章详情";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(editPost)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/**
 *  编辑文章
 */
- (void)editPost{
    NSLog(@"editing post...");
    PostEditViewController *postEditVC = [[PostEditViewController alloc]init];
    postEditVC.post = super.result;
    [self.navigationController pushViewController:postEditVC animated:NO];
}

@end
