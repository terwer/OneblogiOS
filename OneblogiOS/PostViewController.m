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

static NSString *kPostCellID = @"PostCell";//CellID
const int MAX_DESCRIPTION_LENGTH = 60;//描述最多字数
const int MAX_PAGE_SIZE = 10;//每页显示数目
//super.page //当前页码（由于MetaWeblog API不支持分页，因此，此参数仅仅JSON API有用）

@interface PostViewController ()<UISearchResultsUpdating>

@end

@implementation PostViewController

/**
 *  根据文章类型初始化
 *
 *  @param type 文章类型
 *
 *  @return 当前对象
 */
- (instancetype)initWithPostType:(PostType)type
{
    if (self = [super init]) {
        //设置文章类型，仅仅高级API支持
        _postType = type;
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
    if([Config isAnvancedAPIEnable]&&_isSearch){
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableHeaderView = self.searchBar;
        
        //初始化搜索控制器，nil表示搜索结果在当前视囷中显示
        _postSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        //搜索栏宽度自动匹配屏幕宽度
        [_postSearchController.searchBar sizeToFit];
        //在当前视图中显示结果，则此属性必须设置为NO
        _postSearchController.dimsBackgroundDuringPresentation = NO;
        _postSearchController.searchResultsUpdater = self;
        _postSearchController.hidesNavigationBarDuringPresentation =NO;
        self.tableView.tableHeaderView = _postSearchController.searchBar;
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
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = searchController.searchBar.text;
    NSLog(@"searching %@",searchString);
    [self fetchSearchResults:searchString];
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
    NSMutableArray *categroies;//文章分类
    //JSON API
    if ([Config isAnvancedAPIEnable]) {
        title = jsonPost.title;
        content = jsonPost.content;
        dateCreated = [Utils dateFromString:jsonPost.date];
        author = @"";
        categroies = [NSMutableArray array];
        for (SDCategory *category in jsonPost.categoriesArray) {
            [categroies addObject:category.title];
        }
    }else{//MetaWeblogApi
        title = [post objectForKey:@"title"];
        content = [post objectForKey:@"description"];
        dateCreated = [post objectForKey:@"dateCreated"];
        author = [post objectForKey:@"wp_author_display_name"];
        categroies = [post objectForKey:@"categories"];
    }
    
    //表哥数据绑定
    [cell.titleLabel setAttributedText:[Utils attributedTittle:title]];
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
    [self.label setAttributedText:[Utils attributedTittle:title]];
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

#pragma mark - 数据加载

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
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
        NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
        NSInteger digPostCount = [[settings objectForKey:@"DigPostCount"] integerValue];
        //由于置顶文章会影响分页数目，因此需要把他排除
        //另外api里面分页的索引从1开始
        NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_recent_posts/?page=%lu&count=%d&post_type=%@",JSONApiBaseURL,super.page+1,MAX_PAGE_SIZE,(_postType == PostTypePost?@"post":@"page")];
        [jsonAPI parseURL:requestURL success:^(NSArray *posts, NSInteger postsCount) {
            
            NSLog(@"requestURL:%@",requestURL);
            
            NSLog(@"JSON API Fetched %ld posts", postsCount);
            if (self.page == 0) {
                postsCount -= digPostCount;
            }
            NSLog(@"NO dig posts %ld", (long)postsCount);
            
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
                    if (super.page == 0 && postsCount == 0) {//首页无数据
                        super.lastCell.status = LastCellStatusEmpty;
                    }
                    else if (postsCount == 0 || ((postsCount - MAX_PAGE_SIZE)%MAX_PAGE_SIZE > 0)) {
                        //注：当前页面数目小于MAX_PAGE_SIZE或者没有结果表示全部加载完成
                        //另外：默认返回的每页的数目会自动加上置顶文章数目，因此需要修正
                        super.lastCell.status = LastCellStatusFinished;
                        self.page = 0;//最后一页无数据，回到初始页
                    } else {
                        super.lastCell.status = LastCellStatusMore;
                    }
                }
                
                if (self.refreshControl.refreshing) {
                    [self.refreshControl endRefreshing];
                }
                
                [self.tableView reloadData];
            });
            
        }failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else{
        //MetaWeblogAPI
        [self.api getRecentPosts:currentCount
                         success:^(NSArray *posts) {
                             NSLog(@"MetaWeblogAPI have %lu posts", (unsigned long) [posts count]);
                             
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
                                     } else if (posts.count == 0 || posts.count%MAX_PAGE_SIZE > 0) {
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

# pragma mark 加载搜索数据
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

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [_postSearchController.searchBar setShowsCancelButton:YES animated:NO];
    for (UIView *subView in _postSearchController.searchBar.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [(UIButton*)subView setTitle:@"Done" forState:UIControlStateNormal];
        }
    }
}

@end
