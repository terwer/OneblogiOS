

//
//  BlogsViewController.m
//  OneblogiOS
//
//  Created by Terwer Green on 15/7/27.
//  Copyright (c) 2015年 Terwer Green. All rights reserved.
//

#import "BlogsViewController.h"
#import "TGMetaWeblogApi.h"

static NSString *kBlogCellID = @"BlogCell";

@interface BlogsViewController ()

//MetaWeblogApi
@property(nonatomic) id<TGMetaWeblogBaseApi> api;
//文章
@property(nonatomic) NSArray *posts;

@end

@implementation BlogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //检测登陆
    BOOL apiState=[self setupApi];
    if (!apiState) {
        NSLog(@"api初始化失败，请重新登录。");
        return;
    }
    
    [self refreshPosts:self];
    
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

#pragma mark - Private

- (BOOL)setupApi {
    if (self.api == nil) {
        //NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSString *xmlrpc = @"http://www.terwer.com/xmlrpc.php";//[def objectForKey:@"mw_xmlrpc"];
        if (xmlrpc) {
            NSString *username = @"terwer";//[def objectForKey:@"mw_username"];
            NSString *password = @"cbgtyw2020";//[def objectForKey:@"mw_password"];
            if (username && password) {
                self.api = [TGMetaWeblogAuthApi apiWithXMLRPCURL:[NSURL URLWithString:xmlrpc] username:username password:password];
            }
        }
        
    }
    
    //api初始化成功
    if (self.api) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - Custom methods

- (void)refreshPosts:(id)sender {
    [self.api getRecentPosts:10
                     success:^(NSArray *posts) {
                         NSLog(@"We have %lu posts", (unsigned long) [posts count]);
                         self.posts = posts;
                         [self.tableView reloadData];
                     }
                     failure:^(NSError *error) {
                         NSLog(@"Error fetching posts: %@", [error localizedDescription]);
                     }];
}


@end
