//
//  ErrorViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/8/11.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "ErrorViewController.h"
#import "UIColor+Util.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view setBackgroundColor:[UIColor themeColor]];
    
    UILabel *labelMessage = [[UILabel alloc]init];
    labelMessage.text = _errorMessage;
    
    [self.view addSubview:labelMessage];
    
    //去除Autoresize
    for (UIView *view in [self.view subviews]) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    
    //水平居中
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:labelMessage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    //上边距
    NSDictionary *views = NSDictionaryOfVariableBindings(labelMessage);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[labelMessage(20)]" options:NSLayoutAttributeCenterX|NSLayoutAttributeCenterY metrics:nil views:views]];

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

@end
