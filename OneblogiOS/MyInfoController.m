//
//  MyInfoController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "MyInfoController.h"
#import "ApiInfo.h"
#import "LoginNavViewController.h"
#import "Config.h"
#import <RESideMenu.h>
#import "Utils.h"
#import "UIImageView+Util.h"
#import "SDFeedParser.h"

static NSString *kMyInfoCellID = @"myInfoCell";

@interface MyInfoController ()

//@property (nonatomic, readonly, assign) int64_t myID;
@property (nonatomic, strong) NSMutableArray *noticeCounts;

@property (nonatomic,strong) NSArray *authors;

@property (nonatomic, strong) UIImageView *portrait;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *myQRCodeButton;

@property (nonatomic, strong) UIButton *creditsBtn;
@property (nonatomic, strong) UIButton *collectionsBtn;
@property (nonatomic, strong) UIButton *followsBtn;
@property (nonatomic, strong) UIButton *fansBtn;

@property (nonatomic, assign) int badgeValue;

@end

@implementation MyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMyInfoCellID];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationbar-sidebar"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickMenuButton)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.bounces = NO;
    self.navigationItem.title = @"我";
    
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *header = [UIImageView new];
    header.clipsToBounds = YES;
    header.userInteractionEnabled = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    NSNumber *screenWidth = @([UIScreen mainScreen].bounds.size.width);
    NSString *imageName = @"user-background";
    if (screenWidth.intValue < 400) {
        imageName = [NSString stringWithFormat:@"%@-%@", imageName, screenWidth];
    }
    header.image = [UIImage imageNamed:imageName];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header.image.size.width, header.image.size.height)];
    view.backgroundColor = [UIColor infosBackViewColor];
    [header addSubview:view];
    
    _portrait = [UIImageView new];
    _portrait.contentMode = UIViewContentModeScaleAspectFit;
    [_portrait setCornerRadius:25];
    [_portrait loadPortrait:[NSURL URLWithString:@""]];
    _portrait.userInteractionEnabled = YES;
    [_portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)]];
    [header addSubview:_portrait];
    
    //取第一个作者
    NSDictionary *author = _authors[0];
    
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    _nameLabel.textColor = [UIColor colorWithHex:0xEEEEEE];
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@",[author objectForKey:@"first_name"],[author objectForKey:@"last_name"]]?:@"";
    [header addSubview:_nameLabel];
    
    for (UIView *view in header.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _nameLabel);
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_portrait(50)]-8-[_nameLabel]-8-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_portrait(50)]" options:0 metrics:nil views:views]];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:_portrait attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                          toItem:header attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    return header;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    NSArray *title = @[@"昵称：", @"姓名：", @"主页：", @"描述："];
    
    //取第一个作者
    NSDictionary *author = _authors[0];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:title[indexPath.row]
                                                                                       attributes:titleAttributes];
    [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@[
                                                                                        [author objectForKey:@"nickname"]?:@"",
                                                                                        [NSString stringWithFormat:@"%@ %@",[author objectForKey:@"first_name"],[author objectForKey:@"last_name"]]?:    @"",
                                                                                        [author objectForKey:@"url"]?:@"",
                                                                                        [author objectForKey:@"description"]?:@""
                                                                                        ][indexPath.row]]];
    
    cell.textLabel.attributedText = [attributedText copy];
    cell.textLabel.textColor = [UIColor titleColor];
    cell.backgroundColor = [UIColor cellsColor];
    
    return cell;
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)onClickMenuButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)tapPortrait{
    
}

#pragma mark 获取作者数据

/**
 *  加载列表数据
 *
 *  @param page    page
 *  @param refresh refresh
 */
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
    NSLog(@"fetching autoer data...");
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_author_index/",JSONApiBaseURL];
    
    //获取作者数据
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        
        //刷新数据
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSLog(@"JSON: %@", responseObject);
            NSLog(@"status:%@",[result objectForKey:@"status"]);
            NSString *status = [result objectForKey:@"status"];
            if ([status isEqualToString:@"ok"]) {
                NSLog(@"authors get ok");
                //处理刷新
                if (refresh) {
                    super.page = 0;
                    if (super.didRefreshSucceed) {
                        super.didRefreshSucceed();
                    }
                }
                
                //获取数据
                self.authors = [result objectForKey:@"authors"];
                
                //刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    super.lastCell.status = LastCellStatusEmpty;
                    
                    if (self.refreshControl.refreshing) {
                        [self.refreshControl endRefreshing];
                    }
                    
                    [self.tableView reloadData];
                });
            }
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error fetching authors: %@", [error localizedDescription]);
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@", error.userInfo[NSLocalizedDescriptionKey]];
        
        [HUD hide:YES afterDelay:1];
        
        super.lastCell.status = LastCellStatusError;
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    }];
    
}


@end
