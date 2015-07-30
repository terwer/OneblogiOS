

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
#import "PostDetailViewController.h"
#import "Config.h"
#import "SDFeedParser.h"

static NSString *kPostCellID = @"PostCell";
const int MAX_DESCRIPTION_LENGTH = 60;//描述最多字数
const int MAX_PAGE_SIZE = 10;//每页显示数目

@interface PostViewController ()<UISearchDisplayDelegate>
{
    
}
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

//ViewController.m

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[PostCell class] forCellReuseIdentifier:kPostCellID];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //搜索框
    if([Config isAnvancedAPIEnable]){
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
        self.tableView.tableHeaderView = self.searchBar;
        
        _searchDisController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        /*contents controller is the UITableViewController, this let you to reuse
         the same TableViewController Delegate method used for the main table.*/
        
        _searchDisController.delegate = self;
        _searchDisController.searchResultsDataSource = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  处理搜索结果
 *
 *  @param controller   controller
 *  @param searchString searchString
 *
 *  @return 是否重新加载数据
 */
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    NSLog(@"searching for keyword:%@",searchString);
    [self fetchSearchResults:searchString];
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //JSON API
    return _posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPostCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor themeColor];
    
    NSDictionary *post = [self.posts objectAtIndex:indexPath.row];
    SDPost *jsonPost = [self.posts objectAtIndex:indexPath.row];
    
    //博客相关变量
    NSString *title;//文章标题
    NSString *content;//文章内容
    NSDate *dateCreated;//发表时间
    NSString *author;//文章作者
    NSArray *categroies;//文章分类
    //JSON API
    if ([Config isAnvancedAPIEnable]) {
        title = jsonPost.title;
        content = jsonPost.content;
        dateCreated = [Utils dateFromString:jsonPost.date];
        author = @"";
        categroies = jsonPost.categoriesArray;
    }else{//MetaWeblogApi
        title = [post objectForKey:@"title"];
        content = [post objectForKey:@"description"];
        dateCreated = [post objectForKey:@"dateCreated"];
        author = [post objectForKey:@"wp_author_display_name"];
        categroies = [post objectForKey:@"categories"];
    }
    
    //表哥数据绑定
    [cell.titleLabel setAttributedText:[self attributedTittle:title]];
    [cell.bodyLabel setText:[Utils shortString:content andLength:MAX_DESCRIPTION_LENGTH]];
    //作者处理
    [cell.authorLabel setText:(!author||[author isEqual:@""])?@"admin":author];
    cell.titleLabel.textColor = [UIColor titleColor];
    NSDate *createdDate = dateCreated;
    [cell.timeLabel setAttributedText:[Utils attributedTimeString:createdDate]];
    //metaWeblog api暂时不支持评论
    //[cell.commentCount setAttributedText:[self attributedCommentCount:0]];
    NSArray *categories = categroies;
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
    
    SDPost * jsonPost = self.posts[indexPath.row];
    
    //博客相关变量
    NSString *title;//文章标题
    NSString *content;//文章内容
    //JSON API
    if ([Config isAnvancedAPIEnable]) {
        title = jsonPost.title;
        content = jsonPost.content;
    }else{//MetaWeblogApi
        title = [post objectForKey:@"title"];
        content = [post objectForKey:@"description"];
    }
    
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    [self.label setAttributedText:[self attributedTittle:title]];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    self.label.text = [Utils shortString:content andLength:MAX_DESCRIPTION_LENGTH];
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    return height + 42;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *post = self.posts[indexPath.row];
    
    SDPost * jsonPost = self.posts[indexPath.row];
    
    PostDetailViewController *detailsViewController;
    if ([Config isAnvancedAPIEnable]) {
        detailsViewController = [[PostDetailViewController alloc] initWithPost:jsonPost];
    }else{
        detailsViewController = [[PostDetailViewController alloc] initWithPost:post];
    }
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

#pragma mark - Custom methods

/**
 *  加载列表数据
 *
 *  @param page    page
 *  @param refresh refresh
 */
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
    NSInteger currentCount = MAX_PAGE_SIZE+page*MAX_PAGE_SIZE;
    NSLog(@"Tring to get %lu posts...",(long)currentCount);
    //===================================
    //检测api状态
    //===================================
    NSLog(@"Check api status:%@",((self.api == nil)?@"NO":@"YES"));
    if (!self.api) {
        [self.refreshControl endRefreshing];
        
        NSString *errorString = @"api init error";
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
    //JSON API
    if ([Config isAnvancedAPIEnable]) {
        SDFeedParser *jsonAPI = self.api;
        [jsonAPI parseURL:@"http://www.terwer.com/api/get_recent_posts/" success:^(NSArray *postsArray, NSInteger postsCount) {
            NSLog(@"Fetched %ld posts", postsCount);
            self.posts = postsArray;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            
        }failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else{
        //MetaWeblogAPI
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
}


/**
 *  加载搜索数据，仅仅JSON API才支持
 */
-(void)fetchSearchResults:(NSString *)searchString{
    SDFeedParser *jsonAPI = self.api;
    if ([searchString isEqualToString:@""]) {
        searchString = @"ios";
    }
    [jsonAPI parseURL:[NSString stringWithFormat:@"http://www.terwer.com/api/get_search_results/?search=%@",searchString]
              success:^(NSArray *postsArray, NSInteger postsCount) {
        NSLog(@"Fetched %ld posts", postsCount);
        self.posts = postsArray;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    }failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

@end
