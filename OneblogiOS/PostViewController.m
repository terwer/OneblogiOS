

//
//  BlogsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "PostViewController.h"
#import "TGMetaWeblogApi.h"

static NSString *kBlogCellID = @"BlogCell";

@interface PostViewController ()
//文章
@property(nonatomic) NSArray *posts;

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kBlogCellID];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kBlogCellID forIndexPath:indexPath];
    
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
    cell.textLabel.text = [post objectForKey:@"title"];
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

#pragma mark - Custom methods

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
    [self.api getRecentPosts:10
                     success:^(NSArray *posts) {
                         NSLog(@"We have %lu posts", (unsigned long) [posts count]);
                         
                         //处理刷新
                         if (refresh) {
                             super.page = 0;
                             //[_posts remm];
                             if (super.didRefreshSucceed) {
                                 super.didRefreshSucceed();
                             }
                         }
                         
                         //获取数据
                         self.posts = posts;
                         
                         //刷新数据
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if (self.tableWillReload) {self.tableWillReload(posts.count);}
                             else {
                                 if (super.page == 0 && posts.count == 0) {
                                     super.lastCell.status = LastCellStatusEmpty;
                                 } else if (posts.count == 0 || (super.page == 0 && posts.count < 20)) {
                                     super.lastCell.status = LastCellStatusFinished;
                                 } else {
                                     super.lastCell.status = LastCellStatusMore;
                                 }
                             }
                             
                             if (self.refreshControl.refreshing) {
                                 [self.refreshControl endRefreshing];
                             }
                             
                             [self.tableView reloadData];
                         });
                         
                     }
                     failure:^(NSError *error) {
                         NSLog(@"Error fetching posts: %@", [error localizedDescription]);
                     }];
}


@end
