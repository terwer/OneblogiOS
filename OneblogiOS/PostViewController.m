

//
//  BlogsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "PostViewController.h"
#import "TGMetaWeblogApi.h"
#import "PostCell.h"
#import "Utils.h"
#import "DetailsViewController.h"

static NSString *kPostCellID = @"PostCell";
const int MAX_DESCRIPTION_LENGTH = 60;//描述最多字数
const int MAX_PAGE_SIZE = 10;//每页显示数目

@interface PostViewController ()
//文章
@property(nonatomic) NSArray *posts;

@end

@implementation PostViewController

- (instancetype)initWithPostType:(PostType)type
{
    if (self = [super init]) {
        //TODO:do post type
    }
    
    return self;
}

- (NSMutableAttributedString *)attributedTittle:(NSString *)title
{
    NSMutableAttributedString *attributeString ;
    
    NSTextAttachment *textAttachment = [NSTextAttachment new];
    //转载
    //textAttachment.image = [UIImage imageNamed:@"widget_repost"];
    //原创
    textAttachment.image = [UIImage imageNamed:@"widget-original"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attachmentString];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attributeString appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
    
    return attributeString;
}

-(NSAttributedString *)attributedCommentCount:(int)commentCount
{
    return [Utils attributedCommentCount:commentCount];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PostCell class] forCellReuseIdentifier:kPostCellID];
    
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
    
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
    
    cell.backgroundColor = [UIColor themeColor];
    [cell.titleLabel setAttributedText:[self attributedTittle:[post objectForKey:@"title"]]];
    [cell.bodyLabel setText:[Utils shortString:[post objectForKey:@"description"] andLength:MAX_DESCRIPTION_LENGTH]];
    //作者处理
    NSString *author = [post objectForKey:@"wp_author_display_name"];
    [cell.authorLabel setText:(!author||[author isEqual:@""])?@"admin":author];
    cell.titleLabel.textColor = [UIColor titleColor];
    NSDate *createdDate = [post objectForKey:@"dateCreated"];
    [cell.timeLabel setAttributedText:[Utils attributedTimeString:createdDate]];
    //metaWeblog api暂时不支持评论
    //[cell.commentCount setAttributedText:[self attributedCommentCount:0]];
    NSArray *categories = [post objectForKey:@"categories"];
    NSString *joinedString = [Utils shortString:[categories componentsJoinedByString:@","] andLength:15];
    //处理分类为空的情况
    NSString *categoriesString = [NSString stringWithFormat:@"发布在【%@】",[joinedString isEqualToString: @""]?@"默认分类":joinedString];
    cell.categories.text =categoriesString;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *post = self.posts[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    [self.label setAttributedText:[self attributedTittle:[post objectForKey:@"title"]]];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    self.label.text = [Utils shortString:[post objectForKey:@"description"] andLength:MAX_DESCRIPTION_LENGTH];
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    return height + 42;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
    
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] initWithPost:post];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - Custom methods

- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
    NSInteger currentCount = MAX_PAGE_SIZE+page*MAX_PAGE_SIZE;
    NSLog(@"Tring to get %lu posts...",(long)currentCount);
    //===================================
    //检测api状态
    //===================================
    NSLog(@"Check api status:%@",((self.api == nil)?@"NO":@"YES"));
    if (!self.api) {
        [self.refreshControl endRefreshing];
        
        NSString *errorString = @"metaWeblogApi init error";
        NSLog(@"%@",errorString);
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.detailsLabelText = [NSString stringWithFormat:@"%@",errorString];
        
        [HUD hide:YES afterDelay:1];
        return;
    }
    
    //===================================
    //获取文章数据
    //===================================
    [self.api getRecentPosts:currentCount
                     success:^(NSArray *posts) {
                         NSLog(@"We have %lu posts", (unsigned long) [posts count]);
                         
                         //处理刷新
                         if (refresh) {
                             super.page = 0;
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
                                 } else if (posts.count == 0 || (super.page == 0 && posts.count%MAX_PAGE_SIZE > 0)) {
                                     //注：当前页面数目小于MAX_PAGE_SIZE或者没有结果表示全部加载完成
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
