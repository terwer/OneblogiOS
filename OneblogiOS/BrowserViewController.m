//
//  BrowserViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/29.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()

@end

@implementation BrowserViewController

@synthesize url=_url;

-(instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.title = @"MetaWeblog";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(showShare:)];
    
    NSLog(@"即将访问:%@",_url);
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
 *  返回
 */
-(void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  分享
 *
 *  @param sender 当前按钮
 */
-(void)showShare:(id)sender{
    NSLog(@"分享：%@",_url);
}

@end
