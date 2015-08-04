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
#import "DropdownMenuView.h"
#import "TitleMenuViewController.h"

static NSString *kPostCellID = @"PostCell";//CellID
const int MAX_DESCRIPTION_LENGTH = 60;//描述最多字数
const int MAX_PAGE_SIZE = 10;//每页显示数目
//super.page //当前页码（由于MetaWeblog API不支持分页，因此，此参数仅仅JSON API有用）

@interface PostViewController ()<UISearchResultsUpdating,DropdownMenuDelegate, TitleMenuDelegate>

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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //搜索框
    if([Config isAnvancedAPIEnable] && _isSearch){
        
        // 设置导航栏中间的titleView
        _titleButton = [self titleViewWithNickname:@"博客列表"];
        //self.navigationItem.titleView = _titleButton;
        UIViewController *current = [self.navigationController.viewControllers objectAtIndex:0];
        current.navigationItem.titleView = _titleButton;
        
        UIViewController *ctl =  [self.navigationController.viewControllers objectAtIndex:0];
        ctl.navigationItem.rightBarButtonItem = nil;
        
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        self.tableView.tableHeaderView = self.searchBar;
        
        //初始化搜索控制器，nil表示搜索结果在当前视囷中显示
        _postSearchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        //搜索栏宽度自动匹配屏幕宽度
        [_postSearchController.searchBar sizeToFit];
        //在当前视图中显示结果，则此属性必须设置为NO
        _postSearchController.dimsBackgroundDuringPresentation = YES;
        _postSearchController.searchResultsUpdater = self;
        _postSearchController.hidesNavigationBarDuringPresentation =NO;
        self.tableView.tableHeaderView = _postSearchController.searchBar;
    }else{
        //不显示页面的时候才有分类，否则页面会混乱
        if (![Config isShowPage]) {
            // 设置导航栏中间的titleView
            _titleButton = [self titleViewWithNickname:@"博客列表"];
            //self.navigationItem.titleView = _titleButton;
            UIViewController *current = [self.navigationController.viewControllers objectAtIndex:0];
            current.navigationItem.titleView = _titleButton;
        }
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
    
    //为了兼容，利用适配方法
    NSDictionary * adaptedPost = [self adaptPostByAPIType:_apiType post:self.posts[indexPath.row]];
    
    //博客相关变量
    NSString *title = [adaptedPost objectForKey:@"title"];;//文章标题
    NSString *content = [adaptedPost objectForKey:@"content"];//文章内容
    NSDate *dateCreated = [adaptedPost objectForKey:@"date"];//发表时间
    NSString *author = [adaptedPost objectForKey:@"author"];//文章作者
    NSMutableArray *categroies = [adaptedPost objectForKey:@"categroies"];//文章分类
    NSArray *comments = [adaptedPost objectForKey:@"comments"];//评论
    
    //表格数据绑定
    [cell.titleLabel setAttributedText:[Utils attributedTittle:title]];
    [cell.bodyLabel setText:[Utils shortString:content andLength:MAX_DESCRIPTION_LENGTH]];
    //作者处理
    [cell.authorLabel setText:(!author||[author isEqual:@""])?@"admin":author];
    cell.titleLabel.textColor = [UIColor titleColor];
    NSDate *createdDate = dateCreated;
    [cell.timeLabel setAttributedText:[Utils attributedTimeString:createdDate]];
    //metaWeblog api暂时不支持评论
    [cell.commentCount setAttributedText:[Utils attributedCommentCount:(int)comments.count]];
    NSArray *categories = categroies;
    NSString *joinedString = [Utils shortString:[categories componentsJoinedByString:@","] andLength:15];
    //处理分类为空的情况
    NSString *categoriesString = [NSString stringWithFormat:@"  发布在【%@】",[joinedString isEqualToString: @""]?@"默认分类":joinedString];
    cell.categories.text =categoriesString;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //为了兼容，利用适配方法
    NSDictionary * adaptedPost = [self adaptPostByAPIType:_apiType post:self.posts[indexPath.row]];
    
    //博客相关变量
    NSString *title = [adaptedPost objectForKey:@"title"];;//文章标题
    NSString *content = [adaptedPost objectForKey:@"content"];;//文章内容
    
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

#pragma mark 适配文章数据
/**
 *  根据API类型适配文章内容
 *
 *  @param type  API类型
 *  @param post  文章
 *
 *  @return 适配后的文章
 */
-(NSDictionary *)adaptPostByAPIType:(APIType)type post:(id)post{
    NSMutableArray *categroies = [NSMutableArray array];
    NSArray *comments =  [NSMutableArray array];
    
    NSMutableDictionary *adaptedPost = [NSMutableDictionary dictionary];
    switch (type) {
        case APITypeJSON:{
            SDPost *jsonPost = post;
            [adaptedPost setValue:jsonPost.title forKey:@"title"];
            [adaptedPost setValue:jsonPost.content forKey:@"content"];
            [adaptedPost setValue:[Utils dateFromString:jsonPost.date] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            for (SDCategory *category in jsonPost.categoriesArray) {
                [categroies addObject:category.title];
            }
            [adaptedPost setValue:categroies forKey:@"categroies"];
            comments = jsonPost.commentsArray;
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        case APITypeMetaWeblog:{
            [adaptedPost setValue:[post valueForKey:@"title"] forKey:@"title"];
            [adaptedPost setValue:[post valueForKey:@"description"] forKey:@"content"];
            [adaptedPost setValue:[post objectForKey:@"dateCreated"] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            [adaptedPost setValue:categroies forKey:@"categroies"];
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        case APITypeHttp:{
            [adaptedPost setValue:[post objectForKey:@"title"] forKey:@"title"];
            [adaptedPost setValue:[post objectForKey:@"content"] forKey:@"content"];
            [adaptedPost setValue:[Utils dateFromString:[post objectForKey:@"date"]] forKey:@"date"];
            [adaptedPost setValue:@"" forKey:@"author"];
            [adaptedPost setValue:categroies forKey:@"categroies"];
            [adaptedPost setValue:comments forKey:@"comments"];
            break;
        }
        default:
            break;
    }
    return adaptedPost;
}


- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [_postSearchController.searchBar setShowsCancelButton:YES animated:NO];
    for (UIView *subView in _postSearchController.searchBar.subviews){
        if([subView isKindOfClass:[UIButton class]]){
            [(UIButton*)subView setTitle:@"完成" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 数据加载

/**
 *  加载列表数据
 *
 *  @param page    page
 *  @param refresh refresh
 */
- (void)fetchObjectsOnPage:(NSUInteger)page refresh:(BOOL)refresh{
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
    
    //最近文章，搜索文章，分类文章还是标签文章
    switch (_postResultType) {
        case PostResultTypeRecent:
            [self fectchRecentPosts:page refresh:refresh];
            break;
        case PostResultTypeSearch:
         
            break;
        case PostResultTypeCategory:
            [self fetchCategoryResults:_categoryId currentPage:page refresh:refresh];
            break;
        case PostResultTypeTag:
            [self fetchTagResults:_tagId currentPage:page refresh:refresh];
            break;
        default:
            [self fectchRecentPosts:page refresh:refresh];
            break;
    }
    
}

#pragma mark 加载最近文章数据

-(void)fectchRecentPosts:(NSUInteger)page refresh:(BOOL)refresh{
    NSInteger currentCount = MAX_PAGE_SIZE+page*MAX_PAGE_SIZE;
    NSLog(@"Tring to get recent %lu posts...",(long)currentCount);
    
    //===================================
    //获取文章数据
    //===================================
    //JSON API
    if ([Config isAnvancedAPIEnable]) {
        //设置API类型
        self.apiType = APITypeJSON;
        
        SDFeedParser *jsonAPI = self.api;
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
        NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
        NSInteger digPostCount = [[settings objectForKey:@"DigPostCount"] integerValue];
        //由于置顶文章会影响分页数目，因此需要把他排除
        //另外api里面分页的索引从1开始
        NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_recent_posts/?page=%d&count=%d&post_type=%@",JSONApiBaseURL,super.page+1,MAX_PAGE_SIZE,(_postType == PostTypePost?@"post":@"page")];
        [jsonAPI parseURL:requestURL success:^(NSArray *posts, NSInteger postsCount) {
            
            NSLog(@"requestURL:%@",requestURL);
            
            NSLog(@"JSON API Fetched %d posts", postsCount);
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
        //设置API类型
        self.apiType = APITypeMetaWeblog;
        
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
    //设置API类型
    self.apiType = APITypeJSON;
    
    //创建加载中
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.detailsLabelText = @"加载中";
    
    SDFeedParser *jsonAPI = self.api;
    if ([searchString isEqualToString:@""]) {
        searchString = @"ios";
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    [jsonAPI parseURL:[NSString stringWithFormat:@"%@/api/get_search_results/?search=%@",JSONApiBaseURL,searchString]
              success:^(NSArray *postsArray, NSInteger postsCount) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      NSLog(@"Fetched %d posts", postsCount);
                      self.posts = postsArray;
                      [self.tableView reloadData];
                      
                      //取消加载中
                      [HUD hide:YES afterDelay:1];
                  });
              }failure:^(NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    
}


# pragma mark 加载分类数据
/**
 *  加载分类数据，仅仅JSON API才支持
 */
-(void)fetchCategoryResults:(NSUInteger)categortId currentPage:(NSUInteger)page refresh:(BOOL)refresh{
    //设置API类型
    self.apiType = APITypeHttp;
    
    NSLog(@"current categoryId: %lu",(unsigned long)categortId);
    
    //创建加载中
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.detailsLabelText = @"加载中";
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_category_posts/?id=%d&page=%d&count=%d&post_type=post",JSONApiBaseURL,categortId,super.page+1,0];
    
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
                
                //处理刷新
                if (refresh) {
                    super.page = 0;
                    if (super.didRefreshSucceed) {
                        super.didRefreshSucceed();
                    }
                }
                
                //获取数据
                //NSDictionary *dictionaryPosts = [result objectForKey:@"category"];
                NSArray *posts = [result objectForKey:@"posts"];
                self.posts = posts;
                
                NSLog(@"category posts get ok :%d",posts.count);
                
                //刷新数据
                if (self.tableWillReload) {self.tableWillReload(posts.count);}
                else {
                    if (super.page == 0 && posts.count == 0) {//首页无数据
                        super.lastCell.status = LastCellStatusEmpty;
                    }
                    else if (posts.count == 0 || ((posts.count - MAX_PAGE_SIZE)%MAX_PAGE_SIZE > 0)) {
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
                
                [HUD hide:YES afterDelay:1];
            }else{
                NSLog(@"category posts get error");
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


# pragma mark 加载标签数据
/**
 *  加载标签数据，仅仅JSON API才支持
 */
-(void)fetchTagResults:(NSUInteger)tagId currentPage:(NSUInteger)page refresh:(BOOL)refresh{
    //设置API类型
    self.apiType = APITypeHttp;
    
    NSLog(@"current tagId: %lu",(unsigned long)tagId);
    
    //创建加载中
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.detailsLabelText = @"加载中";
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Oneblog" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSString *JSONApiBaseURL = [settings objectForKey:@"JSONApiBaseURL"];
    NSString *requestURL = [NSString stringWithFormat:@"%@/api/get_tag_posts/?id=%lu&page=%u&count=%d&post_type=post",JSONApiBaseURL,(unsigned long)tagId,super.page+1,0];
    
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
                
                //处理刷新
                if (refresh) {
                    super.page = 0;
                    if (super.didRefreshSucceed) {
                        super.didRefreshSucceed();
                    }
                }
                
                //获取数据
                //NSDictionary *dictionaryPosts = [result objectForKey:@"category"];
                NSArray *posts = [result objectForKey:@"posts"];
                self.posts = posts;
                
                NSLog(@"tag posts get ok :%lu",(unsigned long)posts.count);
                
                //刷新数据
                if (self.tableWillReload) {self.tableWillReload(posts.count);}
                else {
                    if (super.page == 0 && posts.count == 0) {//首页无数据
                        super.lastCell.status = LastCellStatusEmpty;
                    }
                    else if (posts.count == 0 || ((posts.count - MAX_PAGE_SIZE)%MAX_PAGE_SIZE > 0)) {
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
                
                [HUD hide:YES afterDelay:1];
            }else{
                NSLog(@"tag posts get error");
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



#pragma mark 设置导航栏中间的titleView
-(UIButton *) titleViewWithNickname:(NSString *)nickname
{
    UIButton *titleButton = [[UIButton alloc] init];
    // 设置图片和文字
    [titleButton setTitle:nickname forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    // 90 40这两个值目前是随便写的
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 90, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    // 130这个值目前是随便写的，后面要改为根据内容自动计算长度
    CGRect titleFrame = titleButton.frame;
    titleFrame.size =  CGSizeMake(130, 40);
    titleButton.frame = titleFrame;
    //    titleButton.backgroundColor = [UIColor redColor];
    
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return titleButton;
}

#pragma mark 点击导航栏上的标题事件处理器
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    DropdownMenuView *dropdownMenuView = [[DropdownMenuView alloc] init];
    // 设置下拉菜单弹出、销毁事件的监听者
    dropdownMenuView.delegate = self;
    
    // 2.设置要显示的内容
    TitleMenuViewController *titleMenuVC = [[TitleMenuViewController alloc] init];
    titleMenuVC.dropdownMenuView = dropdownMenuView;
    titleMenuVC.delegate = self;
    
    CGRect titleMenuFrame =  titleMenuVC.view.frame;
    titleMenuFrame.size.width = self.view.frame.size.width/2;
    titleMenuFrame.size.height = self.view.frame.size.height/2;
    titleMenuVC.view.frame = titleMenuFrame;
    dropdownMenuView.contentController = titleMenuVC;
    
    // 3.显示下拉菜单
    [dropdownMenuView showFrom:titleButton];
}


#pragma mark - DropdownMenuDelegate
#pragma mark 下拉菜单被销毁了
- (void)dropdownMenuDidDismiss:(DropdownMenuView *)menu
{
    // 让指示箭头向下
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}

#pragma mark 下拉菜单显示了
- (void)dropdownMenuDidShow:(DropdownMenuView *)menu
{
    // 让指示箭头向上
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

#pragma mark - TitleMenuDelegate
-(void)selectAtIndexPathAndID:(NSIndexPath *)indexPath ID:(NSInteger)ID title:(NSString *)title
{
    NSLog(@"indexPath = %d", indexPath.row);
    NSLog(@"当前选择了%@", title);
    NSLog(@"当前分类ID %d", ID);

    //修改导航栏的标题
    [_titleButton setTitle:title forState:UIControlStateNormal];
    
    //调用根据搜索条件返回相应的微博数据
    _postResultType = PostResultTypeCategory;
    _categoryId = ID;
    [self fetchObjectsOnPage:super.page refresh:NO];
}
@end
