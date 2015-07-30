
//
//  PostEditViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/30.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "PostEditViewController.h"
#import "PostDetailViewController.h"

@interface PostEditViewController ()

@end

@implementation PostEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"撰写文章";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(preview)];
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
 *  预览
 */
-(void)preview{
    NSLog(@"文章预览。");
    PostDetailViewController *detailsViewController = [[PostDetailViewController alloc] initWithPost:_post];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

@end
